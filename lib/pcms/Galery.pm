package pcms::Galery;
use Carp;
use Data::Dumper;
use warnings;
use strict;

sub new {
  my( $class , $params ) = @_;
  my $self = bless {}, $class;
  $self->_init($params);
  return $self;
}

sub _init{
  my( $self, $params) = @_;
  $params //= {};
  $self->{content_dir} = $params->{content_dir} or croak "content_dir missing";
  unless( -d $self->{content_dir} ){
    die "content_dir $self->{content_dir} missing";
  }
}

sub categories {
  my( $self ) = @_;
  opendir(my $dh, $self->content_dir) || die "can't opendir ".$self->content_dir.": $!";
  my @categories = grep { not( $_ =~ /^\./ or -f $self->content_dir."/$_") } readdir($dh);
  closedir $dh;
  return sort {$a cmp $b} @categories;
}

sub pictures {
  my( $self, $category ) = @_;
  my $types = {
    JPEG => 1,
    JPG => 1,
    PNG => 1,
    GIF => 1,
  };

  my $directory = $self->content_dir."/$category/";
  opendir(my $dh, $directory) || die "can't opendir $directory $!";
  my @pictures = grep { not( /^\./ or -d $directory."/$_" or /thump\./) } readdir($dh);
  closedir $dh;
  my $type_regex = qr/\.(.+?)$/;
  @pictures = grep { my($type) = $_ =~ $type_regex; $types->{uc($type)}} @pictures;

  return map {{
    picture => $category.'/'.$_,
    thumpnail => $self->thumpnail( $category.'/'.$_),
    description => $self->load_description($self->content_dir.'/'.$category.'/'.$_),
  }} sort {$a cmp $b} @pictures;
}

sub content_dir {
   return $_[0]->{content_dir};
}

sub load_description {
  my( $self, $file ) = @_;
  $file =~ s/\.[^\.]+?$/.txt/;
  open( my $fh , '<', $file ) or return '';
  $fh->read( my $buffer, -s $fh);
  return $buffer;
}

sub thumpnail {
  my( $self, $image ) = @_;
  my $thumpnail = $image;
  $thumpnail =~ s/^(.+)(\.[^\.]+)/${1}_thump$2/;
  my $return_thump = $thumpnail;
  $thumpnail = $self->content_dir.'/'.$thumpnail;
  $image     = $self->content_dir.'/'.$image;
  return $return_thump if -f $thumpnail;
  `convert -scale 100 '$image' '$thumpnail'`;
  return $return_thump;

}
  
 

1;
