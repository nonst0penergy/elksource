

file { 'C:\elk\logstash-1.5.4\bin\run.bat':
    replace => "no", # this is the important property
    ensure  => "present",
    content => "logstash.bat agent -f logstash.conf",
    mode    => 0700,
}
