use Test::More;

use FindBin;
BEGIN { unshift @INC, "$FindBin::Bin/../lib" }

use_ok('pcms::Galery');

my $galery = pcms::Galery->new({ 
  content_dir => "$FindBin::Bin/../public/galery/"
});

use Data::Dumper;

ok( (my @categories = $galery->categories), 'categories work');
note(Dumper(@categories));

ok( (my @pictures = $galery->pictures($categories[0])), 'pictures work');


done_testing();
