############ PROG 3 droptest##############
set ns [new Simulator]
set nf [open sim4c.nam w]
set nt [open 4c.tr w]
$ns namtrace-all $nf
$ns trace-all $nt
$ns namtrace-all $nf

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]

$ns duplex-link $n0 $n1 10Mb 1ms DropTail
$ns queue-limit $n0 $n1 3
$ns duplex-link $n1 $n2 10Mb 4ms DropTail
$ns duplex-link-op $n1 $n2 queuePos 0.5

set tcp1 [new Agent/TCP]
$ns attach-agent $n0 $tcp1

set sink1 [new Agent/TCPSink]
$ns attach-agent $n2 $sink1

$ns connect $tcp1 $sink1

set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1

##calling nam
proc finish {} {
    global ns nf
    $ns flush-trace
    close $nf
    exec nam sim4c.nam &
    exit 0
}

$ns at 0.1ms "$ftp1 start"
$ns at 4ms "finish"
$ns run