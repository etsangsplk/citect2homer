#! /bin/sh
# -*-tcl-*- \
	exec tclsh "$0" "$@"
#
# expand-homer.tcl - convert Citect time series data
#   into HOMER data.
#

proc process {} {
  gets stdin
  while {[gets stdin line] > 0} {
    foreach {d t v} [split $line ,] { }
    set t [regsub {[.][0-9]*} $t {}]
    set t [clock scan $d,$t -format "%d/%N/%Y,%H:%M:%S"]
    emit $t $v
  }
}

set t_p 0
set v_p 0

proc emit {t v} {
  if {$::t_p == 0} {
    set ::t_p $t
    set ::v_p $v
  } else {
    while {$::t_p < $t} {
      emit2 $::t_p $::v_p
      incr ::t_p
    }
    set ::t_p $t 
    set ::v_p $v
  }
}

proc emit2 {t v} {
  if {($t % 600) == 0} {
    puts "[clock format $t],$v"
  }
}

process


