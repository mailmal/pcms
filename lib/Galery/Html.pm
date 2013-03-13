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
  $fh->read( my $buffer, -s $fh);
  return $buffer;
}
1;
