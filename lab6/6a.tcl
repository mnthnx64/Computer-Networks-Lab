############Ring Topology######################
set ns [new Simulator]
set nf [open sim6a.nam w]
set nt [open 6a.tr w]
$ns namtrace-all $nf
$ns trace-all $nt

for {set i 0} { $i < 6 } { incr i 1} {
    set n($i) [$ns node]
}

$ns color 1 Red
$ns color 2 Blue

for {set i 0} { $i < 5 } { incr i } {
    $ns duplex-link $n($i) $n([expr $i+1]) 1Mb 10ms DropTail
}
$ns duplex-link $n(0) $n(5) 0.5Mb 10ms DropTail

set tcp [new Agent/TCP]
$ns attach-agent $n(0) $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n(4) $sink
$ns connect $tcp $sink
set ftp [new Application/FTP]
$ftp attach-agent $tcp

set udp0 [new Agent/UDP]
$ns attach-agent $n(1) $udp0
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 500
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0

set null0 [new Agent/Null]
$ns attach-agent $n(5) $null0
$ns connect $udp0 $null0

$udp0 set fid_ 1
$tcp set fid_ 2


##calling nam
proc finish {} {
    global ns nt nf
    $ns flush-trace
    close $nf
    close $nt
    exec nam sim5a.nam &
    exit 0
}

$ns at 0.1 "$cbr0 start"
$ns at 0.2 "$ftp start"

$ns at 1 "finish"
$ns run