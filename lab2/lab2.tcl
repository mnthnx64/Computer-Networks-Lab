##########PROG 1- "Hello World"#####################
# set ns [new Simulator]
# $ns at 1 "puts \"hello world\""
# $ns at 1.5 "exit"
# $ns run


############PROG-2-"Node Communication"###############
# set ns [new Simulator]
# set nf [open sim.nam w]
# $ns namtrace-all $nf
# set n0 [$ns node]
# set n1 [$ns node]
# $ns duplex-link $n0 $n1 1Mb 8ms DropTail
# $ns duplex-link-op $n0 $n1 orient right-up
# set tcp [new Agent/TCP]
# $ns attach-agent $n0 $tcp
# set sink [new Agent/TCPSink]
# $ns attach-agent $n1 $sink
# $ns connect $tcp $sink
# set ftp [new Application/FTP]
# $ftp attach-agent $tcp
# $ns at 0.1ms "$ftp start"
# $ns at 4ms "exit"
# $ns run

##########PROG 3-"Use nam internally with this code##########
set ns [new Simulator]
set nf [open sim.nam w]
$ns namtrace-all $nf
set n0 [$ns node]
set n1 [$ns node]
$ns duplex-link $n0 $n1 1Mb 8ms DropTail
$ns duplex-link-op $n0 $n1 orient right-up
set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n1 $sink
$ns connect $tcp $sink
set ftp [new Application/FTP]
$ftp attach-agent $tcp
##calling nam
proc finish {} {
    global ns nf
    $ns flush-trace
    close $nf
    exec nam sim.nam &
    exit 0
}

$ns at 0.1ms "$ftp start"
$ns at 4ms "finish"
$ns run

#######ALGORITHM##########
#Created a new instance at simulator  class
#open 2 files
#Creating nodes
#Establish link b/w 2 naodes created
#Create transport agents and attach it to appropriate node
#Establish Virtual Connection b/ transport agents
#Create Traffic agent
#Connected traffic agent to appropriate transport agent
#Create finish procedure
#Establish Simulation Timings