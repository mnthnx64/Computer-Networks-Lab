############## PROG 3 - send-receive-send #############
set ns [new Simulator]
# $ns color 1 Red
set nf [open sim3c.nam w]
$ns namtrace-all $nf

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
# $n0 color blue
# $n2 color green

$ns duplex-link $n0 $n1 1Mb 8ms DropTail
$ns duplex-link $n2 $n1 1Mb 8ms DropTail

# $ns duplex-link-op $n0 $n1 orient right-up

set tcp1 [new Agent/TCP]
$ns attach-agent $n0 $tcp1
set tcp2 [new Agent/TCP]
$ns attach-agent $n2 $tcp2

set sink1 [new Agent/TCPSink]
$ns attach-agent $n1 $sink1
set sink2 [new Agent/TCPSink]
$ns attach-agent $n1 $sink2

$ns connect $tcp1 $sink1
$ns connect $tcp2 $sink2

set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2

##calling nam
proc finish {} {
    global ns nf
    $ns flush-trace
    close $nf
    exec nam sim3c.nam &
    exit 0
}

$ns at 0.1ms "$ftp1 start"
$ns at 0.1ms "$ftp2 start"
$ns at 4ms "finish"
$ns run