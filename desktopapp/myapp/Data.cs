namespace myapp
{
    internal class Data
    {
        public string id { get; set; }
        public int fb_temp { get; set; }
        public int fb_humi { get; set; }
        public double fb_light { get; set; }
        public string fb_time { get; internal set; }
    }
}