package Galery::Html;
use Mojo::Base 'Mojolicious::Controller';
use pcms::Galery;
use FindBin;
use Data::Dumper;

# This action will render a template
sub index {
  my $self = shift;
  # Render template "example/welcome.html.ep" with message
  my $galery = pcms::Galery->new({
     content_dir => $ENV{HOME}."/applications/pcms/public/galery" ,
  });

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


1;
