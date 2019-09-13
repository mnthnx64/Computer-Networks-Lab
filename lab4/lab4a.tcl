############## PROG 1 - 4 node connections #############
set ns [new Simulator]
set nf [open sim4a.nam w]
set nt [open 4a.tr w]
$ns namtrace-all $nf
$ns trace-all $nt

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]


$ns duplex-link $n0 $n2 1Mb 8ms DropTail
$ns duplex-link $n1 $n2 1Mb 8ms DropTail
$ns duplex-link $n2 $n3 2Mb 8ms DropTail

$ns queue-limit $n0 $n2 3
$ns queue-limit $n1 $n2 3

set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp

set udp [new Agent/UDP]
$ns attach-agent $n1 $udp

set sink [new Agent/TCPSink]
$ns attach-agent $n3 $sink

set null [new Agent/Null]
$ns attach-agent $n3 $null

$ns connect $tcp $sink
$ns connect $udp $null

set ftp [new Application/FTP]
$ftp attach-agent $tcp
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp


##calling nam
proc finish {} {
    global ns nf nt
    $ns flush-trace
    close $nf
    close $nt
    exec nam sim4a.nam &
    exit 0
}

$ns at 0.1ms "$ftp start"
$ns at 0.1ms "$cbr start"
$ns at 4ms "finish"
$ns run