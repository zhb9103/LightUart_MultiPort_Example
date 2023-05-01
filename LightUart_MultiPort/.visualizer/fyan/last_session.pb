# File saved with Nlview version 2020.22 (04/08/25-18:45:38 bk=1.779)
#
property -reset
property attrcolor #8f8f2f
property autoinst 1
property autoinstnamemax 50
property backgroundcolor #ffffff
property boxcolor0 #000000
property boxcolor1 #999999
property boxcolor2 #ff0000
property boxcolor3 #0000ff
property boxinstcolor #000000
property boxpincolor #000000
property enablescrollrect 1
property fillcolor1 #ffffff
property fillcolor2 #ffffff
property fillcolor3 #ffffff
property incrementmode 2
property instattrmax 50
property medatremove 1
property netcolor #000000
property objecthighlight1 #7f00ff
property objecthighlight2 #ffffff
property objecthighlight3 #0000a0
property objecthighlight4 #00ffff
property objecthighlight6 #ffff00
property objecthighlight7 #ff00ff
property objecthighlight8 #a52a2a
property objecthighlight9 #fa8072
property pinattrmax 50
property pinorder 2
property selectbycolor9 1
property showcellname 0
property showmarks 1
property shownetattr 3
property shownetattrhorizontal 1
property showwirestub 0
property timelimit 1
property undoredomode 1

module new Pathbrowser {} -nosplit
greymode off

module new dummy v -nosplit
load symbol MED_LUT4_AAA8 v BOX portBus O output.right 2 O Oi portBus I0 input.left 2 I0 I0i portBus I1 input.left 2 I1 I1i portBus I2 input.left 2 I2 I2i portBus I3 input.left 2 I3 I3i
load symbol builtin v DEF port -out output -loc 47 0 41 0 port -in input -loc -15 0 -9 0 fillcolor 2 attrdsp @name -cc 16 -18 12 attrdsp othername -cc 16 0 12 attrdsp @marks -cc 16 15 12 attrdsp @attr -cc 16 15 12 fpath -9 0 0 9 0 -9 -9 0 fpath 32 9 32 -9 41 0 32 9 fpath 0 -9 32 -9 32 9 0 9 0 -9
load symbol MED_FDPC_INIT1 v GEN portBus Q output.right 2 Q Qi portBus D input.left 2 D Di portBus CP input.clk.left 2 CP CPi portBus PRE input.top 2 PRE PREi portBus CLR input.bot 2 CLR CLRi
load symbol MED_LUT2_B v BOX portBus O output.right 2 O Oi portBus I0 input.left 2 I0 I0i portBus I1 input.left 2 I1 I1i
load inst Top.dceLoopback.rtlclut_n1000625 MED_LUT2_B v -attr @name ...tlclut_n1000625 -attr @annot DeadLogic -attr @color #7f7f7f -x 919 -y 150 -pg 1
load inst Top.dceLoopback.rtlcreg_rts.med_fd MED_FDPC_INIT1 v -attr @name ...creg_rts.med_fd -attr @annot DeadLogic -attr @color #7f7f7f -x 198 -y 110 -pg 1
load inst Top.dceLoopback.rtlclut_n1001867 MED_LUT4_AAA8 v -attr @name ...tlclut_n1001867 -attr @annot DeadLogic -attr @color #7f7f7f -x 567 -y 40 -pg 1
load net Top.dceLoopback.rtlc_rts_FF_Input_rtlcALW_n3 -pin Top.dceLoopback.rtlclut_n1001867 O -pin Top.dceLoopback.rtlcreg_rts.med_fd D -attr @name ...nput_rtlcALW_n3 -attr @annot DeadLogic -attr @color #7f7f7f -attr @numConns 1 -x 747 -y 40 -pg 1
load net Top.clock10M -pin Top.dceLoopback.rtlcreg_rts.med_fd CP -attr @name Top.clock10M -attr @annot {RtlState ClockNet KeepAlive Reg} -attr @marks {bn,#FF9B38 ct,#FF9B38 ci,#FF9B38 sq,#fa3aca} -attr @color #FF00FF -x 62 -y 50 -pg 1
load net Top.dceLoopback.rtlc_rts_FF_Input -pin Top.dceLoopback.rtlclut_n1000625 O -attr @name ...lc_rts_FF_Input -attr @annot DeadLogic -attr @color #7f7f7f -attr @numConns 1 -x 1093 -y 150 -pg 1
load net Top.cts -pin Top.dceLoopback.rtlclut_n1000625 I0 -pin Top.dceLoopback.rtlclut_n1001867 I0 -pin Top.dceLoopback.rtlcreg_rts.med_fd Q -attr @name Top.cts -attr @annot {DeadLogic RtlState} -attr @marks bn,#FF9B38 -attr @color #7f7f7f -attr @numConns 1 -x 449 -y 40 -pg 1
greymode off
show 1
scrollpos 84 -151

