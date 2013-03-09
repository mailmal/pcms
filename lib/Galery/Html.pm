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
  my $current_cattegory = $self->param('galery') || $categories[0];
  
  my @pictures = $galery->pictures($current_cattegory);

  my %data = map{ $_ => [$galery->pictures($_)]} @categories;
  $self->render(
     template => 'galery/index',
     pictures => [@pictures],
     category => $current_cattegory,
     cat_data => \%data,
  )
}

sub overview {
  my( $self ) = @_;
  my $galery = $self->galery;
  my @categories = $galery->categories;
  require List::MoreUtils;

  my %items = map { $_ => [$galery->pictures($_)] } @categories;
  return $self->render(
    template => 'galery/overview',
    items    => \%items,
  );
}

sub galery {
  my( $self ) = @_;
  return pcms::Galery->new({
     content_dir => File::Basename::dirname(__FILE__)."/../../public/galery" ,
  });
}


1;
