

download_file { "Download elasticsearch" :
      url                   => 'https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.7.2.zip',
     destination_directory => 'c:\temp',

}

download_file { "Download kibana" :
      url                   => 'https://download.elastic.co/kibana/kibana/kibana-4.1.2-windows.zip',
     destination_directory => 'c:\temp',

}
