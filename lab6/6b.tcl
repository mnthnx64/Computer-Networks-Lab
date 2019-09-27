############ Linear Topology ##############
set ns [new Simulator]
set nf [open 6b.nam w]
set nt [open 6b.tr w]
$ns namtrace-all $nf
$ns trace-all $nt

$ns color 1 Red
$ns color 2 Blue

for {set i 0} { $i < 6 } { incr i 1} {
    set n($i) [$ns node]
}

$ns duplex-link $n(0) $n(2) 2Mb 4ms DropTail
$ns duplex-link $n(1) $n(2) 2Mb 4ms DropTail
$ns duplex-link $n(2) $n(3) 2Mb 4ms DropTail

set lan [$ns newLan "$n(3) $n(4) $n(5)" 1Mb 40ms LL Queue/DropTail MAC/802_3 Channel]

# $ns duplex-link $n(0) $n(2) orient right-down
# $ns duplex-link $n(1) $n(2) orient right-up
# $ns duplex-link $n(2) $n(3) orient right

$ns queue-limit $n(2) $n(3) 20
$ns duplex-link-op $n(2) $n(3) queuePos 0.5

set err [new ErrorModel]
$err ranvar [new RandomVariable/Uniform]
$err drop-target [new Agent/Null]
$ns lossmodel $err $n(2) $n(3)

set tcp [new Agent/TCP]
$ns attach-agent $n(0) $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n(4) $sink
$ns connect $tcp $sink

set udp [new Agent/UDP]
$ns attach-agent $n(1) $udp
set null [new Agent/Null]
$ns attach-agent $n(5) $null
$ns connect $udp $null

set ftp [new Application/FTP]
$ftp attach-agent $tcp

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp

$tcp set fid_ 1
$udp set fid_ 2

proc finish {} {
    global ns nf nt
    $ns flush-trace
    close $nf
    close $nt
    exec nam 6b.nam &
    set tcpsize [exec sh f1.sh]
    set tcpnum [exec sh f2.sh]
    set udpsize [exec sh f3.sh]
    set udpnum [exec sh f4.sh]
    set time_of_exec 124.00

    puts "Throughput of TCP is [expr $tcpsize * $tcpnum / $time_of_exec] bytes per sec \n"
    puts "Throughput of UDP is [expr $udpsize * $udpnum / $time_of_exec] bytes per sec \n"
}

$ns at 0.1ms "$ftp start"
$ns at 0.5ms "$cbr start"
$ns at 124 "finish"
$ns run
