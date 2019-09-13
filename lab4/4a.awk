BEGIN {udp=0; tcp=0; drop=0}
{
if ($1=="r" && $5=="cbr")
    {
    udp++;
    }
else if ($1=="r" && $5=="tcp")
    {
    tcp++;
    }
else if ($1=="d" && $5=="tcp")
    {
    drop++;
    }    
}
END {
printf("Number of packets sent by TCP = %d\n",tcp);
printf("Number of packets sent by UDP = %d\n",udp);
printf("Number of packets dropped by TCP = %d\n",drop);
}