package Galery;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
  my $self = shift;

  # Documentation browser under "/perldoc"
  #$self->plugin('PODRenderer');

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/overview/')->to('html#overview');
  $r->get('/')->to( controller => 'html', action => 'index');
  $r->get('/index.html')->to('html#index');
  $r->get('/overview.html')->to('html#overview');


  $r->get('/contact.html')->to('html#contact');
  $r->get('/vita.html')->to('html#vita');
  $r->get('/impressum.html')->to('html#impressum');
  $r->get('/referenzen.html')->to('html#referenzen');

  for my $category ( $self->galery->categories ){
    $r->get("/$category.html")->to( controller => 'html', action => 'index', category => $category);
  }
}

sub galery {
  my( $self ) = @_;
  require pcms::Galery;
  return pcms::Galery->new({
     content_dir => File::Basename::dirname(__FILE__)."/../public/galery" ,
  });
}

1;
