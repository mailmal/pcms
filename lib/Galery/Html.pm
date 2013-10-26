package Galery::Html;
use Mojo::Base 'Mojolicious::Controller';
use pcms::Galery;
use FindBin;
use Data::Dumper;
use File::Basename;

# This action will render a template
sub index {
  my $self = shift;
  # Render template "example/welcome.html.ep" with message
  my $galery = $self->galery;

  my @categories = $galery->categories;
  my $current_cattegory = $self->stash('category') || $categories[0];
  
  my @pictures = $galery->pictures($current_cattegory);
  my $sub_page = $ENV{sub_page} || '';

  $self->render(
     template => 'galery/index',
     pictures => [@pictures],
     category => $current_cattegory,
     categories => [@categories],
     sub_page  => $sub_page,
     company => $self->company,
     industry => $self->industry,
     slogan  => $self->slogan,
  )
}

sub overview {
  my( $self ) = @_;
  my $galery = $self->galery;
  my @categories = $galery->categories;
  require List::MoreUtils;

  my $sub_page = $ENV{sub_page} || '';

  my %items = map { $_ => [$galery->pictures($_)] } @categories;
  return $self->render(
    template => 'galery/overview',
    items    => \%items,
    sub_page  => $sub_page,
    company => $self->company,
    industry => $self->industry,
    slogan  => $self->slogan,
    current_page => { overview => 'selected'},
  );
}

sub contact {
  my( $self ) = @_;
  
  my $sub_page = $ENV{sub_page} || '';
  return $self->render(
    template => 'galery/contact',
    sub_page  => $sub_page,
    company => $self->company,
    industry => $self->industry,
    slogan  => $self->slogan,
    current_page => { contact => 'selected'},
    imported_text    => $self->slurp('../info/contact.txt' ),
  );
}

sub vita {
  my( $self ) = @_;
  
  my $sub_page = $ENV{sub_page} || '';
  return $self->render(
    template => 'galery/vita',
    sub_page  => $sub_page,
    company => $self->company,
    industry => $self->industry,
    slogan  => $self->slogan,
    current_page => { vita => 'selected'},
    imported_text    => [ split /\n/, $self->slurp('../info/vita.txt' )],
  );
}

sub impressum {
  my( $self ) = @_;
  
  my $sub_page = $ENV{sub_page} || '';
  return $self->render(
    template => 'galery/impressum',
    sub_page  => $sub_page,
    company => $self->company,
    industry => $self->industry,
    slogan  => $self->slogan,
    current_page => { impressum => 'selected'},
    imported_text    => $self->slurp('../info/impressum.txt' ),
  );
}

sub referenzen {
  my( $self ) = @_;
  
  my $sub_page = $ENV{sub_page} || '';
  return $self->render(
    template => 'galery/referenzen',
    sub_page  => $sub_page,
    company => $self->company,
    industry => $self->industry,
    slogan  => $self->slogan,
    current_page => { referenzen => 'selected'},
    imported_text    => $self->slurp('../info/referenzen.txt' ),
  );
}

sub galery {
  my( $self ) = @_;
  return pcms::Galery->new({
     content_dir =>  $self->basedir,
  });
}

sub basedir {
  return File::Basename::dirname(__FILE__)."/../../public/galery" ,
}


sub company {
  my( $self ) = @_;
  return $self->slurp( 'company.txt');
}

sub slogan {
  my( $self ) = @_;
  return $self->slurp( 'slogan.txt');
}

sub industry {
  my( $self ) = @_;
  return $self->slurp( 'industry.txt');
}

sub slurp {
  my( $self,$file ) = @_;
  open my $fh, $self->basedir.'/'.$file or return'';
  binmode( $fh );
  use Encode qw(decode encode);
  $fh->read( my $buffer, -s $fh);
  $buffer = decode('UTF-8', $buffer, Encode::FB_CROAK);
  return $buffer || '';;
}
1;
