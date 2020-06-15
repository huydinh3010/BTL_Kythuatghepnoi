
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega328P
;Program type           : Application
;Clock frequency        : 11.059200 MHz
;Memory model           : Small
;Optimize for           : Speed
;(s)printf features     : float, width, precision
;(s)scanf features      : long, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega328P
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x08FF
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _recv_buf_ind=R5
	.DEF _recv_done=R4

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _USART_receive_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0

_0x2F:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF
_0x0:
	.DB  0x25,0x64,0x0,0x30,0x20,0x25,0x64,0x20
	.DB  0x25,0x64,0x20,0x25,0x64,0x0,0x54,0x3A
	.DB  0x25,0x64,0x6F,0x43,0x2C,0x20,0x48,0x3A
	.DB  0x25,0x64,0x25,0x25,0x0,0x4C,0x3A,0x25
	.DB  0x34,0x2E,0x32,0x66,0x25,0x25,0x0,0x2D
	.DB  0x31,0x20,0x25,0x64,0x0,0x31,0x20,0x25
	.DB  0x64,0x20,0x25,0x64,0x20,0x25,0x64,0x0
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x20A0060:
	.DB  0x1
_0x20A0000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  __seed_G105
	.DW  _0x20A0060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	WDR
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	STS  WDTCSR,R31
	STS  WDTCSR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x300

	.CSEG
;#include <mega328p.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;#include <delay.h>
;#include <stdio.h>
;#include <eeprom.h>
;#include <string.h>
;#define BAUD 9600
;#define SYS_CLOCK 11059200
;#define DHT11_PORT PORTB
;#define DHT11_DDR DDRB
;#define DHT11_PIN PINB
;#define DHT11_INPUTPIN 1
;#define DHT11_TIMEOUT 200
;#define V_REF 5.0
;#define LCD_PORT PORTD
;#define LCD_DPIN DDRD
;#define LCD_RSPIN 2
;#define LCD_ENPIN 3
;
;char recv_buf[20];
;char recv_buf_ind = 0;
;char recv_done = 0;
;
;void ADC_init(){
; 0000 0017 void ADC_init(){

	.CSEG
_ADC_init:
; .FSTART _ADC_init
; 0000 0018     // select Vref = AVcc
; 0000 0019     ADMUX |= (1<<REFS0);
	LDS  R30,124
	ORI  R30,0x40
	STS  124,R30
; 0000 001A //    // Left adjust ADC result to allow easy 8 bit reading
; 0000 001B //    ADMUX |= (1 << ADLAR);
; 0000 001C     // set prescaler to 64 and enable ADC
; 0000 001D     ADCSRA |= (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0)| (1 << ADEN);
	LDS  R30,122
	ORI  R30,LOW(0x87)
	STS  122,R30
; 0000 001E }
	RET
; .FEND
;
;unsigned int ADC_read(unsigned char ADCchannel){
; 0000 0020 unsigned int ADC_read(unsigned char ADCchannel){
_ADC_read:
; .FSTART _ADC_read
; 0000 0021     //select ADC channel with safety mask
; 0000 0022     ADMUX = (ADMUX & 0xF0) | (ADCchannel & 0x0F);
	ST   -Y,R26
;	ADCchannel -> Y+0
	LDS  R30,124
	ANDI R30,LOW(0xF0)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF)
	OR   R30,R26
	STS  124,R30
; 0000 0023     //single conversion mode
; 0000 0024     ADCSRA |= (1<<ADSC);
	LDS  R30,122
	ORI  R30,0x40
	STS  122,R30
; 0000 0025     // wait until ADC conversion is complete
; 0000 0026     while( ADCSRA & (1<<ADSC));
_0x3:
	LDS  R30,122
	ANDI R30,LOW(0x40)
	BRNE _0x3
; 0000 0027     return ADCL + (ADCH & 0x03) * 256;
	LDS  R30,120
	LDI  R31,0
	MOVW R26,R30
	LDS  R30,121
	LDI  R31,0
	ANDI R30,LOW(0x3)
	ANDI R31,HIGH(0x3)
	MOV  R31,R30
	LDI  R30,0
	ADD  R30,R26
	ADC  R31,R27
	RJMP _0x20C000C
; 0000 0028 }
; .FEND
;
;void USART_init(unsigned int ubrr){
; 0000 002A void USART_init(unsigned int ubrr){
_USART_init:
; .FSTART _USART_init
; 0000 002B 	// set baud rate
; 0000 002C 	UBRR0H = (unsigned char)(ubrr >> 8);
	ST   -Y,R27
	ST   -Y,R26
;	ubrr -> Y+0
	LDD  R30,Y+1
	STS  197,R30
; 0000 002D 	UBRR0L = (unsigned char)ubrr;
	LD   R30,Y
	STS  196,R30
; 0000 002E 	// enable receiver and transmitter, receive interrupt
; 0000 002F 	UCSR0B = 0x98;
	LDI  R30,LOW(152)
	STS  193,R30
; 0000 0030 	// set frame format: 8 bit data, 1 stop bit
; 0000 0031 	UCSR0C = 0x06;
	LDI  R30,LOW(6)
	STS  194,R30
; 0000 0032 }
	ADIW R28,2
	RET
; .FEND
;
;void USART_put(unsigned char * buf){
; 0000 0034 void USART_put(unsigned char * buf){
_USART_put:
; .FSTART _USART_put
; 0000 0035     int i = 0;
; 0000 0036     while(buf[i] != 0){
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	*buf -> Y+2
;	i -> R16,R17
	__GETWRN 16,17,0
_0x6:
	MOVW R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	CPI  R30,0
	BREQ _0x8
; 0000 0037         while(!(UCSR0A & (1 << UDRE0))); // wait for empty transmit buffer
_0x9:
	LDS  R30,192
	ANDI R30,LOW(0x20)
	BREQ _0x9
; 0000 0038         UDR0 = buf[i];
	MOVW R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	STS  198,R30
; 0000 0039         i++;
	__ADDWRN 16,17,1
; 0000 003A     }
	RJMP _0x6
_0x8:
; 0000 003B     // sending '\n' '\r'
; 0000 003C     while(!(UCSR0A & (1 << UDRE0)));
_0xC:
	LDS  R30,192
	ANDI R30,LOW(0x20)
	BREQ _0xC
; 0000 003D     UDR0 = '\n';
	LDI  R30,LOW(10)
	STS  198,R30
; 0000 003E     while(!(UCSR0A & (1 << UDRE0)));
_0xF:
	LDS  R30,192
	ANDI R30,LOW(0x20)
	BREQ _0xF
; 0000 003F     UDR0 = '\r';
	LDI  R30,LOW(13)
	STS  198,R30
; 0000 0040 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20C000B
; .FEND
;
;interrupt [USART_RXC] void USART_receive_isr (void){
; 0000 0042 interrupt [19] void USART_receive_isr (void){
_USART_receive_isr:
; .FSTART _USART_receive_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0043     recv_buf_ind = (recv_buf_ind + 1) % 20;
	MOV  R30,R5
	LDI  R31,0
	ADIW R30,1
	MOVW R26,R30
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL __MODW21
	MOV  R5,R30
; 0000 0044     recv_buf[recv_buf_ind] = UDR0;
	MOV  R26,R5
	LDI  R27,0
	SUBI R26,LOW(-_recv_buf)
	SBCI R27,HIGH(-_recv_buf)
	LDS  R30,198
	ST   X,R30
; 0000 0045     if(recv_buf[recv_buf_ind] == 'e') recv_done = 1;
	MOV  R30,R5
	LDI  R31,0
	SUBI R30,LOW(-_recv_buf)
	SBCI R31,HIGH(-_recv_buf)
	LD   R26,Z
	CPI  R26,LOW(0x65)
	BRNE _0x12
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0000 0046 }
_0x12:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;void LCD_action(unsigned char cmnd){
; 0000 0048 void LCD_action(unsigned char cmnd){
_LCD_action:
; .FSTART _LCD_action
; 0000 0049     // 4 bit mode
; 0000 004A     LCD_PORT = (LCD_PORT & 0x0F) | (cmnd & 0xF0); // send upper nibble
	ST   -Y,R26
;	cmnd -> Y+0
	IN   R30,0xB
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0xB,R30
; 0000 004B     LCD_PORT &= ~(1 << LCD_RSPIN); // RS = 0
	CBI  0xB,2
; 0000 004C     LCD_PORT |= (1 << LCD_ENPIN); // EN = 1
	SBI  0xB,3
; 0000 004D     delay_us(1);
	__DELAY_USB 4
; 0000 004E     LCD_PORT &= ~(1 << LCD_ENPIN); // EN = 0
	CBI  0xB,3
; 0000 004F     delay_us(200);
	__DELAY_USW 553
; 0000 0050     LCD_PORT = (LCD_PORT & 0x0F) | (cmnd << 4); // send lower nibble
	IN   R30,0xB
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	SWAP R30
	ANDI R30,0xF0
	OR   R30,R26
	OUT  0xB,R30
; 0000 0051     LCD_PORT |= (1 << LCD_ENPIN); // EN = 1
	SBI  0xB,3
; 0000 0052     delay_us(1);
	__DELAY_USB 4
; 0000 0053     LCD_PORT &= ~(1 << LCD_ENPIN); // EN = 0
	CBI  0xB,3
; 0000 0054     delay_ms(2);
	LDI  R26,LOW(2)
	LDI  R27,0
	CALL _delay_ms
; 0000 0055 }
_0x20C000C:
	ADIW R28,1
	RET
; .FEND
;
;void LCD_init(void){
; 0000 0057 void LCD_init(void){
_LCD_init:
; .FSTART _LCD_init
; 0000 0058     LCD_DPIN = 0xFF;
	LDI  R30,LOW(255)
	OUT  0xA,R30
; 0000 0059     delay_ms(20); // wait before LCD activation
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
; 0000 005A     LCD_action(0x02); // 4 bit control
	LDI  R26,LOW(2)
	RCALL _LCD_action
; 0000 005B     LCD_action(0x28); // initialization of 16X2 LCD in 4bit mode
	LDI  R26,LOW(40)
	RCALL _LCD_action
; 0000 005C     LCD_action(0x0C); // disable cursor
	LDI  R26,LOW(12)
	RCALL _LCD_action
; 0000 005D     LCD_action(0x06); // auto increment cursor
	LDI  R26,LOW(6)
	RCALL _LCD_action
; 0000 005E     LCD_action(0x01); // clear LCD
	LDI  R26,LOW(1)
	RCALL _LCD_action
; 0000 005F     LCD_action(0x80); // cursor at home position
	LDI  R26,LOW(128)
	RCALL _LCD_action
; 0000 0060     delay_ms(2);
	LDI  R26,LOW(2)
	LDI  R27,0
	CALL _delay_ms
; 0000 0061 }
	RET
; .FEND
;
;
;void LCD_clear(void){
; 0000 0064 void LCD_clear(void){
_LCD_clear:
; .FSTART _LCD_clear
; 0000 0065     LCD_action(0x01); // clear LCD
	LDI  R26,LOW(1)
	RCALL _LCD_action
; 0000 0066     delay_ms(2);
	LDI  R26,LOW(2)
	LDI  R27,0
	CALL _delay_ms
; 0000 0067     LCD_action(0x80); // move to line 1, position 1
	LDI  R26,LOW(128)
	RCALL _LCD_action
; 0000 0068 }
	RET
; .FEND
;
;void LCD_print(char *str){
; 0000 006A void LCD_print(char *str){
_LCD_print:
; .FSTART _LCD_print
; 0000 006B     int i;
; 0000 006C 	for(i=0; str[i]!=0; i++)
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	*str -> Y+2
;	i -> R16,R17
	__GETWRN 16,17,0
_0x14:
	MOVW R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	CPI  R30,0
	BREQ _0x15
; 0000 006D 	{
; 0000 006E 		LCD_PORT = (LCD_PORT & 0x0F) | (str[i] & 0xF0);
	IN   R30,0xB
	ANDI R30,LOW(0xF)
	MOV  R0,R30
	MOVW R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	ANDI R30,LOW(0xF0)
	OR   R30,R0
	OUT  0xB,R30
; 0000 006F 		LCD_PORT |= (1<<LCD_RSPIN); // RS = 1, data reg
	SBI  0xB,2
; 0000 0070 		LCD_PORT |= (1<<LCD_ENPIN); // EN = 1
	SBI  0xB,3
; 0000 0071 		delay_us(1);
	__DELAY_USB 4
; 0000 0072 		LCD_PORT &= ~ (1<<LCD_ENPIN); // EN = 0
	CBI  0xB,3
; 0000 0073 		delay_us(200);
	__DELAY_USW 553
; 0000 0074 		LCD_PORT = (LCD_PORT & 0x0F) | (str[i] << 4);
	IN   R30,0xB
	ANDI R30,LOW(0xF)
	MOV  R0,R30
	MOVW R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	SWAP R30
	ANDI R30,0xF0
	OR   R30,R0
	OUT  0xB,R30
; 0000 0075 		LCD_PORT |= (1<<LCD_ENPIN);
	SBI  0xB,3
; 0000 0076 		delay_us(1);
	__DELAY_USB 4
; 0000 0077 		LCD_PORT &= ~ (1<<LCD_ENPIN);
	CBI  0xB,3
; 0000 0078 		delay_ms(2);
	LDI  R26,LOW(2)
	LDI  R27,0
	CALL _delay_ms
; 0000 0079 	}
	__ADDWRN 16,17,1
	RJMP _0x14
_0x15:
; 0000 007A }
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20C000B
; .FEND
;
;void LCD_print_pos(char row, char pos, char *str){
; 0000 007C void LCD_print_pos(char row, char pos, char *str){
_LCD_print_pos:
; .FSTART _LCD_print_pos
; 0000 007D     if(row == 0 && pos < 16) // line 1
	ST   -Y,R27
	ST   -Y,R26
;	row -> Y+3
;	pos -> Y+2
;	*str -> Y+0
	LDD  R26,Y+3
	CPI  R26,LOW(0x0)
	BRNE _0x17
	LDD  R26,Y+2
	CPI  R26,LOW(0x10)
	BRLO _0x18
_0x17:
	RJMP _0x16
_0x18:
; 0000 007E         LCD_action((pos & 0x0F)|0x80);
	LDD  R30,Y+2
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	RJMP _0x49
; 0000 007F     else if(row == 1 && pos < 16) // line 2
_0x16:
	LDD  R26,Y+3
	CPI  R26,LOW(0x1)
	BRNE _0x1B
	LDD  R26,Y+2
	CPI  R26,LOW(0x10)
	BRLO _0x1C
_0x1B:
	RJMP _0x1A
_0x1C:
; 0000 0080         LCD_action((pos & 0x0F)|0xC0);
	LDD  R30,Y+2
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
_0x49:
	MOV  R26,R30
	RCALL _LCD_action
; 0000 0081     LCD_print(str);
_0x1A:
	LD   R26,Y
	LDD  R27,Y+1
	RCALL _LCD_print
; 0000 0082 }
_0x20C000B:
	ADIW R28,4
	RET
; .FEND
;
;int read_dht11(int* temp, int* humidity){
; 0000 0084 int read_dht11(int* temp, int* humidity){
_read_dht11:
; .FSTART _read_dht11
; 0000 0085     unsigned char i, j, bytes[5], time_count;
; 0000 0086     //reset port
; 0000 0087     DHT11_DDR |= (1<<DHT11_INPUTPIN); //output mode
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,5
	CALL __SAVELOCR4
;	*temp -> Y+11
;	*humidity -> Y+9
;	i -> R17
;	j -> R16
;	bytes -> Y+4
;	time_count -> R19
	SBI  0x4,1
; 0000 0088     DHT11_PORT |= (1<<DHT11_INPUTPIN); // high
	SBI  0x5,1
; 0000 0089     delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 008A 	// send start signal
; 0000 008B 	DHT11_PORT &= ~(1<<DHT11_INPUTPIN); // low
	CBI  0x5,1
; 0000 008C 	delay_ms(18);
	LDI  R26,LOW(18)
	LDI  R27,0
	CALL _delay_ms
; 0000 008D 	DHT11_PORT |= (1<<DHT11_INPUTPIN); // high
	SBI  0x5,1
; 0000 008E 	DHT11_DDR &= ~(1<<DHT11_INPUTPIN); //input mode
	CBI  0x4,1
; 0000 008F 	delay_us(40);
	__DELAY_USB 147
; 0000 0090     // check DHT response signal
; 0000 0091     if((DHT11_PIN & (1 << DHT11_INPUTPIN))){
	SBIS 0x3,1
	RJMP _0x1D
; 0000 0092         // error
; 0000 0093         return -1;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C000A
; 0000 0094     }
; 0000 0095     delay_us(80);
_0x1D:
	__DELAY_USW 221
; 0000 0096     // check DHT pulls up
; 0000 0097     if(!(DHT11_PIN & (1 << DHT11_INPUTPIN))){
	SBIC 0x3,1
	RJMP _0x1E
; 0000 0098         // error
; 0000 0099         return -2;
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	RJMP _0x20C000A
; 0000 009A     }
; 0000 009B     delay_us(80);
_0x1E:
	__DELAY_USW 221
; 0000 009C     // read 5 bytes
; 0000 009D     for(i = 0; i < 5; i++){
	LDI  R17,LOW(0)
_0x20:
	CPI  R17,5
	BRSH _0x21
; 0000 009E         unsigned char result = 0;
; 0000 009F         for(j = 0; j < 8; j++){
	SBIW R28,1
	LDI  R30,LOW(0)
	ST   Y,R30
;	*temp -> Y+12
;	*humidity -> Y+10
;	bytes -> Y+5
;	result -> Y+0
	LDI  R16,LOW(0)
_0x23:
	CPI  R16,8
	BRSH _0x24
; 0000 00A0             time_count = 0;
	LDI  R19,LOW(0)
; 0000 00A1             // wait for a high voltage
; 0000 00A2             while(!(DHT11_PIN & (1 << DHT11_INPUTPIN))){
_0x25:
	SBIC 0x3,1
	RJMP _0x27
; 0000 00A3                 time_count++;
	SUBI R19,-1
; 0000 00A4                 if(time_count > DHT11_TIMEOUT) return -3; // timeout error
	CPI  R19,201
	BRLO _0x28
	LDI  R30,LOW(65533)
	LDI  R31,HIGH(65533)
	ADIW R28,1
	RJMP _0x20C000A
; 0000 00A5                 delay_us(1);
_0x28:
	__DELAY_USB 4
; 0000 00A6             }
	RJMP _0x25
_0x27:
; 0000 00A7             delay_us(30);
	__DELAY_USB 111
; 0000 00A8             if(DHT11_PIN & (1 << DHT11_INPUTPIN)) // high after 30 us -> bit 1
	SBIS 0x3,1
	RJMP _0x29
; 0000 00A9                 result |= (1<<(7-j));
	LDI  R30,LOW(7)
	SUB  R30,R16
	LDI  R26,LOW(1)
	CALL __LSLB12
	LD   R26,Y
	OR   R30,R26
	ST   Y,R30
; 0000 00AA             time_count = 0;
_0x29:
	LDI  R19,LOW(0)
; 0000 00AB             // wait until get low
; 0000 00AC             while(DHT11_PIN & (1 << DHT11_INPUTPIN)){
_0x2A:
	SBIS 0x3,1
	RJMP _0x2C
; 0000 00AD                 time_count++;
	SUBI R19,-1
; 0000 00AE                 if(time_count > DHT11_TIMEOUT) return -3; // timeout error
	CPI  R19,201
	BRLO _0x2D
	LDI  R30,LOW(65533)
	LDI  R31,HIGH(65533)
	ADIW R28,1
	RJMP _0x20C000A
; 0000 00AF                 delay_us(1);
_0x2D:
	__DELAY_USB 4
; 0000 00B0             }
	RJMP _0x2A
_0x2C:
; 0000 00B1         }
	SUBI R16,-1
	RJMP _0x23
_0x24:
; 0000 00B2         bytes[i] = result;
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,5
	ADD  R30,R26
	ADC  R31,R27
	LD   R26,Y
	STD  Z+0,R26
; 0000 00B3     }
	ADIW R28,1
	SUBI R17,-1
	RJMP _0x20
_0x21:
; 0000 00B4     // reset port
; 0000 00B5     DHT11_DDR |= (1<<DHT11_INPUTPIN); //output mode
	SBI  0x4,1
; 0000 00B6     DHT11_PORT |= (1<<DHT11_INPUTPIN); // high
	SBI  0x5,1
; 0000 00B7     delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 00B8     // checksum
; 0000 00B9     if((unsigned char)(bytes[0] + bytes[1] + bytes[2] + bytes[3]) == bytes[4]){
	LDD  R26,Y+4
	CLR  R27
	LDD  R30,Y+5
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDD  R30,Y+6
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDD  R30,Y+7
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOV  R26,R30
	LDD  R30,Y+8
	CP   R30,R26
	BRNE _0x2E
; 0000 00BA         *temp = bytes[2];
	LDD  R30,Y+6
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
; 0000 00BB //        *temp = *temp << 8;
; 0000 00BC //        *temp = *temp | bytes[3];
; 0000 00BD         *humidity = bytes[0];
	LDD  R30,Y+4
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
; 0000 00BE //        *humidity = *humidity << 8;
; 0000 00BF //        *humidity = *humidity | bytes[1];
; 0000 00C0         return 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x20C000A
; 0000 00C1     }
; 0000 00C2     // checksum error
; 0000 00C3     return -4;
_0x2E:
	LDI  R30,LOW(65532)
	LDI  R31,HIGH(65532)
_0x20C000A:
	CALL __LOADLOCR4
	ADIW R28,13
	RET
; 0000 00C4 }
; .FEND
;
;void main(void){
; 0000 00C6 void main(void){
_main:
; .FSTART _main
; 0000 00C7     int temp, humidity, err_code, light, temp_threshold = -1, humidity_threshold = -1, light_threshold = -1;
; 0000 00C8     char i, j, recv_data[20], loop_count = 0, *p;
; 0000 00C9     char mss[24];
; 0000 00CA     #asm("sei ");
	SBIW R28,57
	LDI  R24,29
	LDI  R26,LOW(26)
	LDI  R27,HIGH(26)
	LDI  R30,LOW(_0x2F*2)
	LDI  R31,HIGH(_0x2F*2)
	CALL __INITLOCB
;	temp -> R16,R17
;	humidity -> R18,R19
;	err_code -> R20,R21
;	light -> Y+55
;	temp_threshold -> Y+53
;	humidity_threshold -> Y+51
;	light_threshold -> Y+49
;	i -> Y+48
;	j -> Y+47
;	recv_data -> Y+27
;	loop_count -> Y+26
;	*p -> Y+24
;	mss -> Y+0
	sei 
; 0000 00CB     // ADC init - ADC6
; 0000 00CC     ADC_init();
	RCALL _ADC_init
; 0000 00CD 	USART_init(SYS_CLOCK/16/BAUD - 1);
	LDI  R26,LOW(71)
	LDI  R27,0
	RCALL _USART_init
; 0000 00CE     LCD_init();
	RCALL _LCD_init
; 0000 00CF     // init led pin
; 0000 00D0     DDRB |= 0x1C; // 2,3,4
	IN   R30,0x4
	ORI  R30,LOW(0x1C)
	OUT  0x4,R30
; 0000 00D1     temp_threshold = eeprom_read_word(0);
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	CALL __EEPROMRDW
	STD  Y+53,R30
	STD  Y+53+1,R31
; 0000 00D2     humidity_threshold = eeprom_read_word(2);
	LDI  R26,LOW(2)
	LDI  R27,HIGH(2)
	CALL __EEPROMRDW
	STD  Y+51,R30
	STD  Y+51+1,R31
; 0000 00D3     light_threshold = eeprom_read_word(4);
	LDI  R26,LOW(4)
	LDI  R27,HIGH(4)
	CALL __EEPROMRDW
	STD  Y+49,R30
	STD  Y+49+1,R31
; 0000 00D4     //USART_put("Hello from ATmega328p");
; 0000 00D5 	while(1){
_0x30:
; 0000 00D6         // check uart data received
; 0000 00D7         loop_count++;
	LDD  R30,Y+26
	SUBI R30,-LOW(1)
	STD  Y+26,R30
; 0000 00D8         if(recv_done){
	TST  R4
	BRNE PC+2
	RJMP _0x33
; 0000 00D9             recv_done = 0;
	CLR  R4
; 0000 00DA             for(i = 0; i < 20; i++) // find 's';
	LDI  R30,LOW(0)
	STD  Y+48,R30
_0x35:
	LDD  R26,Y+48
	CPI  R26,LOW(0x14)
	BRSH _0x36
; 0000 00DB                 if(recv_buf[i] == 's') break;
	LDD  R30,Y+48
	LDI  R31,0
	SUBI R30,LOW(-_recv_buf)
	SBCI R31,HIGH(-_recv_buf)
	LD   R26,Z
	CPI  R26,LOW(0x73)
	BREQ _0x36
; 0000 00DC             if(i != 20){
	LDD  R30,Y+48
	SUBI R30,-LOW(1)
	STD  Y+48,R30
	RJMP _0x35
_0x36:
	LDD  R26,Y+48
	CPI  R26,LOW(0x14)
	BRNE PC+2
	RJMP _0x38
; 0000 00DD                 j = (i + 1) % 20;
	LDD  R30,Y+48
	LDI  R31,0
	ADIW R30,1
	MOVW R26,R30
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL __MODW21
	STD  Y+47,R30
; 0000 00DE                 memset(recv_data, 0, 20);
	MOVW R30,R28
	ADIW R30,27
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _memset
; 0000 00DF                 while(j != i){
_0x39:
	LDD  R30,Y+48
	LDD  R26,Y+47
	CP   R30,R26
	BREQ _0x3B
; 0000 00E0                     if(recv_buf[j] == 'e') break;
	LDD  R30,Y+47
	LDI  R31,0
	SUBI R30,LOW(-_recv_buf)
	SBCI R31,HIGH(-_recv_buf)
	LD   R26,Z
	CPI  R26,LOW(0x65)
	BREQ _0x3B
; 0000 00E1                     recv_data[(j-i+20)%20-1] = recv_buf[j];
	LDD  R26,Y+47
	CLR  R27
	LDD  R30,Y+48
	LDI  R31,0
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	ADIW R30,20
	MOVW R26,R30
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL __MODW21
	SBIW R30,1
	MOVW R26,R28
	ADIW R26,27
	ADD  R26,R30
	ADC  R27,R31
	LDD  R30,Y+47
	LDI  R31,0
	SUBI R30,LOW(-_recv_buf)
	SBCI R31,HIGH(-_recv_buf)
	LD   R30,Z
	ST   X,R30
; 0000 00E2                     j = (j+1) % 20;
	LDD  R30,Y+47
	LDI  R31,0
	ADIW R30,1
	MOVW R26,R30
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL __MODW21
	STD  Y+47,R30
; 0000 00E3                 }
	RJMP _0x39
_0x3B:
; 0000 00E4                 if(j != i){
	LDD  R30,Y+48
	LDD  R26,Y+47
	CP   R30,R26
	BRNE PC+2
	RJMP _0x3D
; 0000 00E5                     i = 0;
	LDI  R30,LOW(0)
	STD  Y+48,R30
; 0000 00E6                     p = strrchr(recv_data, ' ');
	MOVW R30,R28
	ADIW R30,27
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(32)
	CALL _strrchr
	STD  Y+24,R30
	STD  Y+24+1,R31
; 0000 00E7                     sscanf(p + 1, "%d", &light_threshold);
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,53
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sscanf
	ADIW R28,8
; 0000 00E8                     *p = 0;
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 00E9                     p = strrchr(recv_data, ' ');
	MOVW R30,R28
	ADIW R30,27
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(32)
	CALL _strrchr
	STD  Y+24,R30
	STD  Y+24+1,R31
; 0000 00EA                     sscanf(p + 1, "%d", &humidity_threshold);
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,55
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sscanf
	ADIW R28,8
; 0000 00EB                     *p = 0;
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 00EC                     p = strrchr(recv_data, ' ');
	MOVW R30,R28
	ADIW R30,27
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(32)
	CALL _strrchr
	STD  Y+24,R30
	STD  Y+24+1,R31
; 0000 00ED                     sscanf(p + 1, "%d", &temp_threshold);
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,57
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sscanf
	ADIW R28,8
; 0000 00EE                     // eeprom  write
; 0000 00EF                     eeprom_write_word(0, temp_threshold);
	LDD  R30,Y+53
	LDD  R31,Y+53+1
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	CALL __EEPROMWRW
; 0000 00F0                     eeprom_write_word(2, humidity_threshold);
	LDD  R30,Y+51
	LDD  R31,Y+51+1
	LDI  R26,LOW(2)
	LDI  R27,HIGH(2)
	CALL __EEPROMWRW
; 0000 00F1                     eeprom_write_word(4, light_threshold);
	LDD  R30,Y+49
	LDD  R31,Y+49+1
	LDI  R26,LOW(4)
	LDI  R27,HIGH(4)
	CALL __EEPROMWRW
; 0000 00F2                 }
; 0000 00F3             }
_0x3D:
; 0000 00F4         }
_0x38:
; 0000 00F5 
; 0000 00F6 
; 0000 00F7         if(loop_count % 10 == 0){ // read rht11 sensor after every 1s
_0x33:
	LDD  R26,Y+26
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SBIW R30,0
	BREQ PC+2
	RJMP _0x3E
; 0000 00F8             light = ADC_read(6);
	LDI  R26,LOW(6)
	RCALL _ADC_read
	STD  Y+55,R30
	STD  Y+55+1,R31
; 0000 00F9             if((err_code = read_dht11(&temp, &humidity)) == 0){
	IN   R30,SPL
	IN   R31,SPH
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	PUSH R17
	PUSH R16
	IN   R26,SPL
	IN   R27,SPH
	SBIW R26,1
	PUSH R19
	PUSH R18
	RCALL _read_dht11
	POP  R18
	POP  R19
	POP  R16
	POP  R17
	MOVW R20,R30
	SBIW R30,0
	BREQ PC+2
	RJMP _0x3F
; 0000 00FA                 sprintf(mss, "0 %d %d %d", temp, humidity, light);
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,3
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R16
	CALL __CWD1
	CALL __PUTPARD1
	MOVW R30,R18
	CALL __CWD1
	CALL __PUTPARD1
	__GETW1SX 67
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
; 0000 00FB                 USART_put(mss);
	MOVW R26,R28
	RCALL _USART_put
; 0000 00FC                 // LCD update
; 0000 00FD                 LCD_clear();
	RCALL _LCD_clear
; 0000 00FE                 sprintf(mss, "T:%doC, H:%d%%", temp, humidity);
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,14
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R16
	CALL __CWD1
	CALL __PUTPARD1
	MOVW R30,R18
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
; 0000 00FF                 LCD_print(mss);
	MOVW R26,R28
	RCALL _LCD_print
; 0000 0100                 sprintf(mss, "L:%4.2f%%", light*100.0/1024);
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,29
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+59
	LDD  R31,Y+59+1
	CALL __CWD1
	CALL __CDF1
	__GETD2N 0x42C80000
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x44800000
	CALL __DIVF21
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 0101                 LCD_print_pos(1, 0, mss);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,2
	RCALL _LCD_print_pos
; 0000 0102 
; 0000 0103             } else{
	RJMP _0x40
_0x3F:
; 0000 0104                 sprintf(mss, "-1 %d", err_code);
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,39
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 0105                 USART_put(mss);
	MOVW R26,R28
	RCALL _USART_put
; 0000 0106             }
_0x40:
; 0000 0107         }
; 0000 0108 
; 0000 0109         if(loop_count >= 55){ // send threshold
_0x3E:
	LDD  R26,Y+26
	CPI  R26,LOW(0x37)
	BRLO _0x41
; 0000 010A             loop_count = 0;
	LDI  R30,LOW(0)
	STD  Y+26,R30
; 0000 010B             sprintf(mss, "1 %d %d %d", temp_threshold, humidity_threshold, light_threshold);
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,45
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+57
	LDD  R31,Y+57+1
	CALL __CWD1
	CALL __PUTPARD1
	LDD  R30,Y+59
	LDD  R31,Y+59+1
	CALL __CWD1
	CALL __PUTPARD1
	LDD  R30,Y+61
	LDD  R31,Y+61+1
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
; 0000 010C             USART_put(mss);
	MOVW R26,R28
	RCALL _USART_put
; 0000 010D         }
; 0000 010E 
; 0000 010F         // check threshold
; 0000 0110         PORTB.2 = temp_threshold < temp;
_0x41:
	MOVW R30,R16
	LDD  R26,Y+53
	LDD  R27,Y+53+1
	CALL __LTW12
	CPI  R30,0
	BRNE _0x42
	CBI  0x5,2
	RJMP _0x43
_0x42:
	SBI  0x5,2
_0x43:
; 0000 0111         PORTB.3 = humidity_threshold < humidity;
	MOVW R30,R18
	LDD  R26,Y+51
	LDD  R27,Y+51+1
	CALL __LTW12
	CPI  R30,0
	BRNE _0x44
	CBI  0x5,3
	RJMP _0x45
_0x44:
	SBI  0x5,3
_0x45:
; 0000 0112         PORTB.4 = light_threshold > light;
	LDD  R30,Y+55
	LDD  R31,Y+55+1
	LDD  R26,Y+49
	LDD  R27,Y+49+1
	CALL __GTW12
	CPI  R30,0
	BRNE _0x46
	CBI  0x5,4
	RJMP _0x47
_0x46:
	SBI  0x5,4
_0x47:
; 0000 0113 
; 0000 0114 		delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 0115 	}
	RJMP _0x30
; 0000 0116 }
_0x48:
	RJMP _0x48
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG
_put_buff_G100:
; .FSTART _put_buff_G100
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2000016
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000018
	__CPWRN 16,17,2
	BRLO _0x2000019
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000018:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2000019:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x200001A
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x200001A:
	RJMP _0x200001B
_0x2000016:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x200001B:
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x20C0004
; .FEND
__ftoe_G100:
; .FSTART __ftoe_G100
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	CALL __SAVELOCR4
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x200001F
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2000000,0
	CALL _strcpyf
	RJMP _0x20C0009
_0x200001F:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x200001E
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2000000,1
	CALL _strcpyf
	RJMP _0x20C0009
_0x200001E:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x2000021
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x2000021:
	LDD  R17,Y+11
_0x2000022:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2000024
	__GETD2S 4
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 4
	RJMP _0x2000022
_0x2000024:
	__GETD1S 12
	CALL __CPD10
	BRNE _0x2000025
	LDI  R19,LOW(0)
	__GETD2S 4
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 4
	RJMP _0x2000026
_0x2000025:
	LDD  R19,Y+11
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2000027
	__GETD2S 4
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 4
_0x2000028:
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	BRLO _0x200002A
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__PUTD1S 12
	SUBI R19,-LOW(1)
	RJMP _0x2000028
_0x200002A:
	RJMP _0x200002B
_0x2000027:
_0x200002C:
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	BRSH _0x200002E
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 12
	SUBI R19,LOW(1)
	RJMP _0x200002C
_0x200002E:
	__GETD2S 4
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 4
_0x200002B:
	__GETD1S 12
	__GETD2N 0x3F000000
	CALL __ADDF12
	__PUTD1S 12
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	BRLO _0x200002F
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__PUTD1S 12
	SUBI R19,-LOW(1)
_0x200002F:
_0x2000026:
	LDI  R17,LOW(0)
_0x2000030:
	LDD  R30,Y+11
	CP   R30,R17
	BRSH PC+2
	RJMP _0x2000032
	__GETD2S 4
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__GETD2N 0x3F000000
	CALL __ADDF12
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	__PUTD1S 4
	__GETD2S 12
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2S 4
	CALL __MULF12
	__GETD2S 12
	CALL __SWAPD12
	CALL __SUBF12
	__PUTD1S 12
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BREQ _0x2000033
	RJMP _0x2000030
_0x2000033:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x2000030
_0x2000032:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	SBIW R30,1
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x2000034
	NEG  R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(45)
	RJMP _0x200011C
_0x2000034:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(43)
_0x200011C:
	ST   X,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20C0009:
	CALL __LOADLOCR4
	ADIW R28,16
	RET
; .FEND
__print_G100:
; .FSTART __print_G100
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,63
	SBIW R28,17
	CALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 88
	STD  Y+8,R30
	STD  Y+8+1,R31
	__GETW1SX 86
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000036:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000038
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200003C
	CPI  R18,37
	BRNE _0x200003D
	LDI  R17,LOW(1)
	RJMP _0x200003E
_0x200003D:
	ST   -Y,R18
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
_0x200003E:
	RJMP _0x200003B
_0x200003C:
	CPI  R30,LOW(0x1)
	BRNE _0x200003F
	CPI  R18,37
	BRNE _0x2000040
	ST   -Y,R18
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RJMP _0x200011D
_0x2000040:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+21,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000041
	LDI  R16,LOW(1)
	RJMP _0x200003B
_0x2000041:
	CPI  R18,43
	BRNE _0x2000042
	LDI  R30,LOW(43)
	STD  Y+21,R30
	RJMP _0x200003B
_0x2000042:
	CPI  R18,32
	BRNE _0x2000043
	LDI  R30,LOW(32)
	STD  Y+21,R30
	RJMP _0x200003B
_0x2000043:
	RJMP _0x2000044
_0x200003F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000045
_0x2000044:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000046
	ORI  R16,LOW(128)
	RJMP _0x200003B
_0x2000046:
	RJMP _0x2000047
_0x2000045:
	CPI  R30,LOW(0x3)
	BRNE _0x2000048
_0x2000047:
	CPI  R18,48
	BRLO _0x200004A
	CPI  R18,58
	BRLO _0x200004B
_0x200004A:
	RJMP _0x2000049
_0x200004B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200003B
_0x2000049:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x200004C
	LDI  R17,LOW(4)
	RJMP _0x200003B
_0x200004C:
	RJMP _0x200004D
_0x2000048:
	CPI  R30,LOW(0x4)
	BRNE _0x200004F
	CPI  R18,48
	BRLO _0x2000051
	CPI  R18,58
	BRLO _0x2000052
_0x2000051:
	RJMP _0x2000050
_0x2000052:
	ORI  R16,LOW(32)
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x200003B
_0x2000050:
_0x200004D:
	CPI  R18,108
	BRNE _0x2000053
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x200003B
_0x2000053:
	RJMP _0x2000054
_0x200004F:
	CPI  R30,LOW(0x5)
	BREQ PC+2
	RJMP _0x200003B
_0x2000054:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2000059
	__GETW1SX 90
	SBIW R30,4
	__PUTW1SX 90
	LDD  R26,Z+4
	ST   -Y,R26
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RJMP _0x200005A
_0x2000059:
	CPI  R30,LOW(0x45)
	BREQ _0x200005D
	CPI  R30,LOW(0x65)
	BRNE _0x200005E
_0x200005D:
	RJMP _0x200005F
_0x200005E:
	CPI  R30,LOW(0x66)
	BREQ PC+2
	RJMP _0x2000060
_0x200005F:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	__GETW2SX 90
	CALL __GETD1P
	__PUTD1S 10
	__GETW1SX 90
	SBIW R30,4
	__PUTW1SX 90
	LDD  R26,Y+13
	TST  R26
	BRMI _0x2000061
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x2000063
	CPI  R26,LOW(0x20)
	BREQ _0x2000065
	RJMP _0x2000066
_0x2000061:
	__GETD1S 10
	CALL __ANEGF1
	__PUTD1S 10
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2000063:
	SBRS R16,7
	RJMP _0x2000067
	LDD  R30,Y+21
	ST   -Y,R30
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RJMP _0x2000068
_0x2000067:
_0x2000065:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2000068:
_0x2000066:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x200006A
	__GETD1S 10
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	CALL _ftoa
	RJMP _0x200006B
_0x200006A:
	__GETD1S 10
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	RCALL __ftoe_G100
_0x200006B:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlen
	MOV  R17,R30
	RJMP _0x200006C
_0x2000060:
	CPI  R30,LOW(0x73)
	BRNE _0x200006E
	__GETW1SX 90
	SBIW R30,4
	__PUTW1SX 90
	__GETW2SX 90
	ADIW R26,4
	CALL __GETW1P
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlen
	MOV  R17,R30
	RJMP _0x200006F
_0x200006E:
	CPI  R30,LOW(0x70)
	BRNE _0x2000071
	__GETW1SX 90
	SBIW R30,4
	__PUTW1SX 90
	__GETW2SX 90
	ADIW R26,4
	CALL __GETW1P
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x200006F:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x2000073
	CP   R20,R17
	BRLO _0x2000074
_0x2000073:
	RJMP _0x2000072
_0x2000074:
	MOV  R17,R20
_0x2000072:
_0x200006C:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x2000075
_0x2000071:
	CPI  R30,LOW(0x64)
	BREQ _0x2000078
	CPI  R30,LOW(0x69)
	BRNE _0x2000079
_0x2000078:
	ORI  R16,LOW(4)
	RJMP _0x200007A
_0x2000079:
	CPI  R30,LOW(0x75)
	BRNE _0x200007B
_0x200007A:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x200007C
	__GETD1N 0x3B9ACA00
	__PUTD1S 16
	LDI  R17,LOW(10)
	RJMP _0x200007D
_0x200007C:
	__GETD1N 0x2710
	__PUTD1S 16
	LDI  R17,LOW(5)
	RJMP _0x200007D
_0x200007B:
	CPI  R30,LOW(0x58)
	BRNE _0x200007F
	ORI  R16,LOW(8)
	RJMP _0x2000080
_0x200007F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x20000BE
_0x2000080:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x2000082
	__GETD1N 0x10000000
	__PUTD1S 16
	LDI  R17,LOW(8)
	RJMP _0x200007D
_0x2000082:
	__GETD1N 0x1000
	__PUTD1S 16
	LDI  R17,LOW(4)
_0x200007D:
	CPI  R20,0
	BREQ _0x2000083
	ANDI R16,LOW(127)
	RJMP _0x2000084
_0x2000083:
	LDI  R20,LOW(1)
_0x2000084:
	SBRS R16,1
	RJMP _0x2000085
	__GETW1SX 90
	SBIW R30,4
	__PUTW1SX 90
	__GETW2SX 90
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x200011E
_0x2000085:
	SBRS R16,2
	RJMP _0x2000087
	__GETW1SX 90
	SBIW R30,4
	__PUTW1SX 90
	__GETW2SX 90
	ADIW R26,4
	CALL __GETW1P
	CALL __CWD1
	RJMP _0x200011E
_0x2000087:
	__GETW1SX 90
	SBIW R30,4
	__PUTW1SX 90
	__GETW2SX 90
	ADIW R26,4
	CALL __GETW1P
	CLR  R22
	CLR  R23
_0x200011E:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x2000089
	LDD  R26,Y+13
	TST  R26
	BRPL _0x200008A
	__GETD1S 10
	CALL __ANEGD1
	__PUTD1S 10
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x200008A:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x200008B
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x200008C
_0x200008B:
	ANDI R16,LOW(251)
_0x200008C:
_0x2000089:
	MOV  R19,R20
_0x2000075:
	SBRC R16,0
	RJMP _0x200008D
_0x200008E:
	CP   R17,R21
	BRSH _0x2000091
	CP   R19,R21
	BRLO _0x2000092
_0x2000091:
	RJMP _0x2000090
_0x2000092:
	SBRS R16,7
	RJMP _0x2000093
	SBRS R16,2
	RJMP _0x2000094
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x2000095
_0x2000094:
	LDI  R18,LOW(48)
_0x2000095:
	RJMP _0x2000096
_0x2000093:
	LDI  R18,LOW(32)
_0x2000096:
	ST   -Y,R18
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	SUBI R21,LOW(1)
	RJMP _0x200008E
_0x2000090:
_0x200008D:
_0x2000097:
	CP   R17,R20
	BRSH _0x2000099
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200009A
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW2SX 87
	__GETW1SX 89
	ICALL
	CPI  R21,0
	BREQ _0x200009B
	SUBI R21,LOW(1)
_0x200009B:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x200009A:
	LDI  R30,LOW(48)
	ST   -Y,R30
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	CPI  R21,0
	BREQ _0x200009C
	SUBI R21,LOW(1)
_0x200009C:
	SUBI R20,LOW(1)
	RJMP _0x2000097
_0x2000099:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x200009D
_0x200009E:
	CPI  R19,0
	BREQ _0x20000A0
	SBRS R16,3
	RJMP _0x20000A1
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x20000A2
_0x20000A1:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x20000A2:
	ST   -Y,R18
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	CPI  R21,0
	BREQ _0x20000A3
	SUBI R21,LOW(1)
_0x20000A3:
	SUBI R19,LOW(1)
	RJMP _0x200009E
_0x20000A0:
	RJMP _0x20000A4
_0x200009D:
_0x20000A6:
	__GETD1S 16
	__GETD2S 10
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x20000A8
	SBRS R16,3
	RJMP _0x20000A9
	SUBI R18,-LOW(55)
	RJMP _0x20000AA
_0x20000A9:
	SUBI R18,-LOW(87)
_0x20000AA:
	RJMP _0x20000AB
_0x20000A8:
	SUBI R18,-LOW(48)
_0x20000AB:
	SBRC R16,4
	RJMP _0x20000AD
	CPI  R18,49
	BRSH _0x20000AF
	__GETD2S 16
	__CPD2N 0x1
	BRNE _0x20000AE
_0x20000AF:
	RJMP _0x20000B1
_0x20000AE:
	CP   R20,R19
	BRSH _0x200011F
	CP   R21,R19
	BRLO _0x20000B4
	SBRS R16,0
	RJMP _0x20000B5
_0x20000B4:
	RJMP _0x20000B3
_0x20000B5:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20000B6
_0x200011F:
	LDI  R18,LOW(48)
_0x20000B1:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20000B7
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW2SX 87
	__GETW1SX 89
	ICALL
	CPI  R21,0
	BREQ _0x20000B8
	SUBI R21,LOW(1)
_0x20000B8:
_0x20000B7:
_0x20000B6:
_0x20000AD:
	ST   -Y,R18
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	CPI  R21,0
	BREQ _0x20000B9
	SUBI R21,LOW(1)
_0x20000B9:
_0x20000B3:
	SUBI R19,LOW(1)
	__GETD1S 16
	__GETD2S 10
	CALL __MODD21U
	__PUTD1S 10
	LDD  R30,Y+20
	__GETD2S 16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	__PUTD1S 16
	CALL __CPD10
	BREQ _0x20000A7
	RJMP _0x20000A6
_0x20000A7:
_0x20000A4:
	SBRS R16,0
	RJMP _0x20000BA
_0x20000BB:
	CPI  R21,0
	BREQ _0x20000BD
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RJMP _0x20000BB
_0x20000BD:
_0x20000BA:
_0x20000BE:
_0x200005A:
_0x200011D:
	LDI  R17,LOW(0)
_0x200003B:
	RJMP _0x2000036
_0x2000038:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,31
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	SBIW R30,0
	BRNE _0x20000BF
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0008
_0x20000BF:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20C0008:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND
_get_buff_G100:
; .FSTART _get_buff_G100
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(0)
	ST   X,R30
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LD   R30,X
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x20000C7
	LDI  R30,LOW(0)
	ST   X,R30
	RJMP _0x20000C8
_0x20000C7:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,1
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x20000C9
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	LDD  R26,Z+1
	LDD  R27,Z+2
	LD   R30,X
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x20000CA
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,1
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x20000CA:
	RJMP _0x20000CB
_0x20000C9:
	LDI  R17,LOW(0)
_0x20000CB:
_0x20000C8:
	MOV  R30,R17
	LDD  R17,Y+0
	RJMP _0x20C0004
; .FEND
__scanf_G100:
; .FSTART __scanf_G100
	PUSH R15
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STD  Y+10,R30
	STD  Y+10+1,R31
	MOV  R20,R30
_0x20000CC:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R19,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x20000CE
	MOV  R26,R19
	CALL _isspace
	CPI  R30,0
	BREQ _0x20000CF
_0x20000D0:
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ICALL
	POP  R20
	MOV  R19,R30
	CPI  R30,0
	BREQ _0x20000D3
	MOV  R26,R19
	CALL _isspace
	CPI  R30,0
	BRNE _0x20000D4
_0x20000D3:
	RJMP _0x20000D2
_0x20000D4:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LD   R26,X
	CPI  R26,0
	BRGE _0x20000D5
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0006
_0x20000D5:
	RJMP _0x20000D0
_0x20000D2:
	MOV  R20,R19
	RJMP _0x20000D6
_0x20000CF:
	CPI  R19,37
	BREQ PC+2
	RJMP _0x20000D7
	LDI  R21,LOW(0)
_0x20000D8:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	LPM  R19,Z+
	STD  Y+18,R30
	STD  Y+18+1,R31
	CPI  R19,48
	BRLO _0x20000DC
	CPI  R19,58
	BRLO _0x20000DB
_0x20000DC:
	RJMP _0x20000DA
_0x20000DB:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R19
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x20000D8
_0x20000DA:
	CPI  R19,0
	BRNE _0x20000DE
	RJMP _0x20000CE
_0x20000DE:
_0x20000DF:
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ICALL
	POP  R20
	MOV  R18,R30
	MOV  R26,R30
	CALL _isspace
	CPI  R30,0
	BREQ _0x20000E1
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LD   R26,X
	CPI  R26,0
	BRGE _0x20000E2
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0006
_0x20000E2:
	RJMP _0x20000DF
_0x20000E1:
	CPI  R18,0
	BRNE _0x20000E3
	RJMP _0x20000E4
_0x20000E3:
	MOV  R20,R18
	CPI  R21,0
	BRNE _0x20000E5
	LDI  R21,LOW(255)
_0x20000E5:
	CLT
	BLD  R15,3
	MOV  R30,R19
	CPI  R30,LOW(0x63)
	BRNE _0x20000E9
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R16,X+
	LD   R17,X
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ICALL
	POP  R20
	MOVW R26,R16
	ST   X,R30
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LD   R26,X
	CPI  R26,0
	BRGE _0x20000EA
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0006
_0x20000EA:
	RJMP _0x20000E8
_0x20000E9:
	CPI  R30,LOW(0x73)
	BRNE _0x20000EB
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R16,X+
	LD   R17,X
_0x20000EC:
	MOV  R30,R21
	SUBI R21,1
	CPI  R30,0
	BREQ _0x20000EE
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ICALL
	POP  R20
	MOV  R19,R30
	CPI  R30,0
	BREQ _0x20000F0
	MOV  R26,R19
	CALL _isspace
	CPI  R30,0
	BREQ _0x20000EF
_0x20000F0:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LD   R26,X
	CPI  R26,0
	BRGE _0x20000F2
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0006
_0x20000F2:
	RJMP _0x20000EE
_0x20000EF:
	PUSH R17
	PUSH R16
	__ADDWRN 16,17,1
	MOV  R30,R19
	POP  R26
	POP  R27
	ST   X,R30
	RJMP _0x20000EC
_0x20000EE:
	MOVW R26,R16
	LDI  R30,LOW(0)
	ST   X,R30
	RJMP _0x20000E8
_0x20000EB:
	CPI  R30,LOW(0x6C)
	BRNE _0x20000F4
	SET
	BLD  R15,3
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	LPM  R19,Z+
	STD  Y+18,R30
	STD  Y+18+1,R31
_0x20000F4:
	SET
	BLD  R15,1
	CLT
	BLD  R15,2
	MOV  R30,R19
	CPI  R30,LOW(0x64)
	BREQ _0x20000F9
	CPI  R30,LOW(0x69)
	BRNE _0x20000FA
_0x20000F9:
	CLT
	BLD  R15,1
	RJMP _0x20000FB
_0x20000FA:
	CPI  R30,LOW(0x75)
	BRNE _0x20000FC
_0x20000FB:
	LDI  R18,LOW(10)
	RJMP _0x20000F7
_0x20000FC:
	CPI  R30,LOW(0x78)
	BRNE _0x20000FD
	LDI  R18,LOW(16)
	RJMP _0x20000F7
_0x20000FD:
	CPI  R30,LOW(0x25)
	BRNE _0x2000100
	RJMP _0x20000FF
_0x2000100:
	RJMP _0x20C0007
_0x20000F7:
	LDI  R30,LOW(0)
	__CLRD1S 6
	SET
	BLD  R15,0
_0x2000101:
	MOV  R30,R21
	SUBI R21,1
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000103
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ICALL
	POP  R20
	MOV  R19,R30
	CPI  R30,LOW(0x21)
	BRSH _0x2000104
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LD   R26,X
	CPI  R26,0
	BRGE _0x2000105
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0006
_0x2000105:
	RJMP _0x2000106
_0x2000104:
	SBRC R15,1
	RJMP _0x2000107
	SET
	BLD  R15,1
	CPI  R19,45
	BRNE _0x2000108
	BLD  R15,2
	RJMP _0x2000101
_0x2000108:
	CPI  R19,43
	BREQ _0x2000101
_0x2000107:
	CPI  R18,16
	BRNE _0x200010A
	MOV  R26,R19
	CALL _isxdigit
	CPI  R30,0
	BREQ _0x2000106
	RJMP _0x200010C
_0x200010A:
	MOV  R26,R19
	CALL _isdigit
	CPI  R30,0
	BRNE _0x200010D
_0x2000106:
	SBRC R15,0
	RJMP _0x200010F
	MOV  R20,R19
	RJMP _0x2000103
_0x200010D:
_0x200010C:
	CPI  R19,97
	BRLO _0x2000110
	SUBI R19,LOW(87)
	RJMP _0x2000111
_0x2000110:
	CPI  R19,65
	BRLO _0x2000112
	SUBI R19,LOW(55)
	RJMP _0x2000113
_0x2000112:
	SUBI R19,LOW(48)
_0x2000113:
_0x2000111:
	MOV  R30,R18
	__GETD2S 6
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __MULD12U
	MOVW R26,R30
	MOVW R24,R22
	MOV  R30,R19
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __ADDD12
	__PUTD1S 6
	CLT
	BLD  R15,0
	RJMP _0x2000101
_0x2000103:
	SBRS R15,2
	RJMP _0x2000114
	__GETD1S 6
	CALL __ANEGD1
	__PUTD1S 6
_0x2000114:
	SBRS R15,3
	RJMP _0x2000115
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R16,X+
	LD   R17,X
	__GETD1S 6
	MOVW R26,R16
	CALL __PUTDP1
	RJMP _0x2000116
_0x2000115:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R16,X+
	LD   R17,X
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	MOVW R26,R16
	ST   X+,R30
	ST   X,R31
_0x2000116:
_0x20000E8:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ADIW R30,1
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x2000117
_0x20000D7:
_0x20000FF:
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ICALL
	POP  R20
	CP   R30,R19
	BREQ _0x2000118
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LD   R26,X
	CPI  R26,0
	BRGE _0x2000119
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0006
_0x2000119:
_0x20000E4:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SBIW R30,0
	BRNE _0x200011A
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0006
_0x200011A:
	RJMP _0x20000CE
_0x2000118:
_0x2000117:
_0x20000D6:
	RJMP _0x20000CC
_0x20000CE:
_0x200010F:
_0x20C0007:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
_0x20C0006:
	CALL __LOADLOCR6
	ADIW R28,20
	POP  R15
	RET
; .FEND
_sscanf:
; .FSTART _sscanf
	PUSH R15
	MOV  R15,R24
	SBIW R28,3
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,7
	CALL __ADDW2R15
	CALL __GETW1P
	SBIW R30,0
	BRNE _0x200011B
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0005
_0x200011B:
	MOVW R26,R28
	ADIW R26,1
	CALL __ADDW2R15
	MOVW R16,R26
	MOVW R26,R28
	ADIW R26,7
	CALL __ADDW2R15
	CALL __GETW1P
	STD  Y+3,R30
	STD  Y+3+1,R31
	MOVW R26,R28
	ADIW R26,5
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_get_buff_G100)
	LDI  R31,HIGH(_get_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __scanf_G100
_0x20C0005:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	POP  R15
	RET
; .FEND

	.CSEG

	.CSEG
_memset:
; .FSTART _memset
	ST   -Y,R27
	ST   -Y,R26
    ldd  r27,y+1
    ld   r26,y
    adiw r26,0
    breq memset1
    ldd  r31,y+4
    ldd  r30,y+3
    ldd  r22,y+2
memset0:
    st   z+,r22
    sbiw r26,1
    brne memset0
memset1:
    ldd  r30,y+3
    ldd  r31,y+4
_0x20C0004:
	ADIW R28,5
	RET
; .FEND
_strcpyf:
; .FSTART _strcpyf
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
; .FEND
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND
_strrchr:
; .FSTART _strrchr
	ST   -Y,R26
    ld   r22,y+
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strrchr0:
    ld   r23,x
    cp   r22,r23
    brne strrchr1
    movw r30,r26
strrchr1:
    adiw r26,1
    tst  r23
    brne strrchr0
    ret
; .FEND

	.CSEG
_isdigit:
; .FSTART _isdigit
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    cpi  r31,'0'
    brlo isdigit0
    cpi  r31,'9'+1
    brlo isdigit1
isdigit0:
    clr  r30
isdigit1:
    ret
; .FEND
_isspace:
; .FSTART _isspace
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    cpi  r31,' '
    breq isspace1
    cpi  r31,9
    brlo isspace0
    cpi  r31,13+1
    brlo isspace1
isspace0:
    clr  r30
isspace1:
    ret
; .FEND
_isxdigit:
; .FSTART _isxdigit
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    subi r31,0x30
    brcs isxdigit0
    cpi  r31,10
    brcs isxdigit1
    andi r31,0x5f
    subi r31,7
    cpi  r31,10
    brcs isxdigit0
    cpi  r31,16
    brcs isxdigit1
isxdigit0:
    clr  r30
isxdigit1:
    ret
; .FEND

	.CSEG
_ftrunc:
; .FSTART _ftrunc
	CALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
; .FEND
_floor:
; .FSTART _floor
	CALL __PUTPARD2
	CALL __GETD2S0
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL __GETD1S0
	RJMP _0x20C0003
__floor1:
    brtc __floor0
	CALL __GETD1S0
	__GETD2N 0x3F800000
	CALL __SUBF12
_0x20C0003:
	ADIW R28,4
	RET
; .FEND

	.CSEG
_ftoa:
; .FSTART _ftoa
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x20A000D
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x20A0000,0
	CALL _strcpyf
	RJMP _0x20C0002
_0x20A000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x20A000C
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x20A0000,1
	CALL _strcpyf
	RJMP _0x20C0002
_0x20A000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x20A000F
	__GETD1S 9
	CALL __ANEGF1
	__PUTD1S 9
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	LDI  R30,LOW(45)
	ST   X,R30
_0x20A000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x20A0010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x20A0010:
	LDD  R17,Y+8
_0x20A0011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x20A0013
	__GETD2S 2
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__PUTD1S 2
	RJMP _0x20A0011
_0x20A0013:
	__GETD1S 2
	__GETD2S 9
	CALL __ADDF12
	__PUTD1S 9
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	__PUTD1S 2
_0x20A0014:
	__GETD1S 2
	__GETD2S 9
	CALL __CMPF12
	BRLO _0x20A0016
	__GETD2S 2
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 2
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x20A0017
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x20A0000,5
	CALL _strcpyf
	RJMP _0x20C0002
_0x20A0017:
	RJMP _0x20A0014
_0x20A0016:
	CPI  R17,0
	BRNE _0x20A0018
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x20A0019
_0x20A0018:
_0x20A001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BRNE PC+2
	RJMP _0x20A001C
	__GETD2S 2
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__GETD2N 0x3F000000
	CALL __ADDF12
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	__PUTD1S 2
	__GETD2S 9
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	LDI  R31,0
	__GETD2S 2
	CALL __CWD1
	CALL __CDF1
	CALL __MULF12
	__GETD2S 9
	CALL __SWAPD12
	CALL __SUBF12
	__PUTD1S 9
	RJMP _0x20A001A
_0x20A001C:
_0x20A0019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x20C0001
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	LDI  R30,LOW(46)
	ST   X,R30
_0x20A001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x20A0020
	__GETD2S 9
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 9
	CALL __CFD1U
	MOV  R16,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	LDI  R31,0
	__GETD2S 9
	CALL __CWD1
	CALL __CDF1
	CALL __SWAPD12
	CALL __SUBF12
	__PUTD1S 9
	RJMP _0x20A001E
_0x20A0020:
_0x20C0001:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20C0002:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET
; .FEND

	.DSEG

	.CSEG

	.DSEG
_recv_buf:
	.BYTE 0x14
__seed_G105:
	.BYTE 0x4

	.CSEG

	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xACD
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__LTW12:
	CP   R26,R30
	CPC  R27,R31
	LDI  R30,1
	BRLT __LTW12T
	CLR  R30
__LTW12T:
	RET

__GTW12:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BRLT __GTW12T
	CLR  R30
__GTW12T:
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVB21:
	RCALL __CHKSIGNB
	RCALL __DIVB21U
	BRTC __DIVB211
	NEG  R30
__DIVB211:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
