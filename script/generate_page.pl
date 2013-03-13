#!/usr/bin/env perl
use warnings;
use strict;

use FindBin;
BEGIN { unshift @INC, "$FindBin::Bin/../lib" }
use pcms::Galery;
my $galery = pcms::Galery->new({
 content_dir => $FindBin::Bin.'/../public/galery/', 
});

my $base_dir = $FindBin::Bin.'/../generated/'.time;
my $sub_page = $ARGV[0] || '.';

$ENV{sub_page} = $sub_page;

system("mkdir -p $base_dir/$sub_page");

copy_content();

for my $category ( $galery->categories ){
  save_page("/$category.html");
}

save_page("/index.html");
save_page("/overview.html");

sub save_page {
  my( $route ) = @_;
  my $page = `perl $FindBin::Bin/pcms get $route`;
  open my $fh, '>', "$base_dir/$sub_page/$route" or die $!."$base_dir/$sub_page/$route";
  print $fh $page;
}

sub copy_content {
  my $public_path = $FindBin::Bin.'/../public';
  my $cmd = "cp -r $public_path/* $base_dir/$sub_page/";
  system $cmd;
}
