﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Threading;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.IO.Ports;
using LiveCharts;
using LiveCharts.Defaults;
using LiveCharts.Wpf;
using System.Globalization;

using FireSharp.Config;
using FireSharp.Interfaces;
using FireSharp.Response;

namespace myapp
{

    public partial class MainWindow : Window
    {
        IFirebaseConfig config = new FirebaseConfig
        {
            AuthSecret = "Pd8KeC3RWz5pbhclB3PMtnK3I0J90udGgoRuNIJa",
            BasePath = "https://ki-thuat-ghep-noi.firebaseio.com/"
        };

        IFirebaseClient client;

        SerialPort sp = new SerialPort();
        int temp;
        int humidity;
        int i_temp;
        int i_humidity;
        int light;
        DateTime time; // curent time

        int temp_thres;
        int humidity_thres;
        int light_thres;

        ChartValues<ObservableValue> TempValues = new ChartValues<ObservableValue> {};
        ChartValues<ObservableValue> HumiValues = new ChartValues<ObservableValue> {};
        ChartValues<ObservableValue> LightValues = new ChartValues<ObservableValue> {};

        public MainWindow()
        {
            InitializeComponent();

            /// Timer document: https://www.wpf-tutorial.com/misc/dispatchertimer/
            DispatcherTimer timer = new DispatcherTimer();
            timer.Interval = TimeSpan.FromSeconds(1);
            timer.Tick += timer_Tick;
            timer.Start();
            ///

            

            SeriesCollection = new SeriesCollection
            {
                new LineSeries
                {
                    Title = "Humidity",
                    LabelPoint = point => point.Y + "%",
                    Values = HumiValues,
                    PointGeometry = null

                },
                new LineSeries
                {
                    Title = "Temperature",
                    LabelPoint = point => point.Y + "°C",
                    Values = TempValues,
                    PointGeometry = null


                },
                new LineSeries
                {
                    Title = "Light",
                    LabelPoint = point => point.Y + "%",
                    Values = LightValues,
                    PointGeometry = null

                }
            };
            ///

            Labels = new[] { "" };
            DataContext = this;
        }
        public SeriesCollection SeriesCollection { get; set; }
        public string[] Labels { get; set; }
        public Func<double, string> XFormatter { get; set; }

        void timer_Tick(object sender, EventArgs e)
        {
            currentTime.Content = DateTime.Now.ToString("h:mm:ss tt");
        }

        private void ComboBox_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            var selectedcomboitem = sender as ComboBox;
            string name = selectedcomboitem.SelectedItem as string;
        }

        private void Conect_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                string portName = COM.SelectedItem as string;
                sp.PortName = portName;
                sp.BaudRate = 9600;
                sp.DataReceived += new SerialDataReceivedEventHandler(DataReceiveHandler);
                sp.Open();
                status.Text = "Connected";

                client = new FireSharp.FirebaseClient(config);

                if (client != null)
                {
                    firebase.Text = "Connected";
                }
            }
            catch (Exception)
            {
                MessageBox.Show("Pls give a valid port number or check your connection!");
            }
        }

        private void Disconnect_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                sp.Close();
                status.Text = "Disconnected";
            }
            catch (Exception)
            {
                MessageBox.Show("Can not disconnect!");
            }
        }

        private void ON_Click(object sender, RoutedEventArgs e)
        {
            light_thres = int.Parse(nguong_anh_sang.Text);
            humidity_thres = int.Parse(nguong_do_am.Text);
            temp_thres = int.Parse(nguong_nhiet_do.Text) ;
            string str = "s " + temp_thres + " " + humidity_thres + " " + light_thres + "e";
            ON.IsEnabled = false;
            Console.Write(str);
            sp.Write(str);
        }

        private async void insertToFireBase(Data data)
        {
            SetResponse response = await client.SetTaskAsync(data.id + "/" + data.fb_time, data);
            Data result = response.ResultAs<Data>();

            Console.Write("Firebase inserted: ");
            Console.WriteLine(result);
        }

        /* Data format : 
         * [0 a a1 b b1 c] 
         * 0: success
         * a: int part of temp
         * a1: after floating point part of temp
         * b: int part of humi
         * b1: after floating point part of humi
         * c: light value (0-1023)
         */
        private void DataReceiveHandler(object sender, SerialDataReceivedEventArgs e)
        {
            try
            {
                string indata = sp.ReadLine();
                string[] s = indata.Split(' ');
                if (s[0].Trim() == "0")
                {
                    temp = int.Parse(s[1]);
                    i_temp = int.Parse(s[2]);
                    humidity = int.Parse(s[3]);
                    i_humidity = int.Parse(s[4]);
                    light = int.Parse(s[5]);
                    time = DateTime.Now;

                    this.Dispatcher.Invoke(() =>
                    {
                        TempValues.Add(new ObservableValue(Math.Round(float.Parse(temp.ToString() + "." + i_temp.ToString()), 1)));
                        HumiValues.Add(new ObservableValue(Math.Round(float.Parse(humidity.ToString() + "." + i_humidity.ToString()), 1)));
                        LightValues.Add(new ObservableValue(Math.Round(light * 100.0 / 1024, 2)));
                        Labels.Append(DateTime.Now.ToString());
                        nhiet_do.Text = temp.ToString() + "." + i_temp.ToString() + "°C";
                        do_am.Text = humidity.ToString() + "." + i_humidity.ToString() + "%";
                        anh_sang.Text = Math.Round(light * 100.0 / 1024, 2).ToString() + "%";

                        // insert to firebase
                        var data = new Data
                        {
                            id = time.ToString("yyyy/MM/dd"),
                            fb_time = time.ToString("h:mm:ss tt"),
                            fb_temp = temp,
                            fb_humi = humidity,
                            fb_light = Math.Round(light * 100.0 / 1024, 2)
                        };
                        insertToFireBase(data);

                        // write log
                        using (System.IO.StreamWriter file =
                        new System.IO.StreamWriter(@"log.txt", true))
                        {
                            file.WriteLine( time.ToString("yyyy/MM/dd h:mm:ss tt") + " - Temp: " + temp + "°C, Humidity: " + humidity + "%, Light: " + Math.Round(light * 100.0 / 1024, 2) + "%");
                        }
                    });
                }
                else if (s[0].Trim() == "1")
                {
                    temp_thres = int.Parse(s[1]);
                    humidity_thres = int.Parse(s[2]);
                    light_thres = int.Parse(s[3]);

                    this.Dispatcher.Invoke(() =>
                    {
                        ON.IsEnabled = true;
                        nguong_nhiet_do.Text = temp_thres.ToString();
                        nguong_do_am.Text = humidity_thres.ToString();
                        nguong_anh_sang.Text = light_thres.ToString();
                    });
                }
                //Console.Write("Data:");
                //Console.WriteLine(indata);
            }
            catch (Exception)
            {

            };
        }
    }

}
