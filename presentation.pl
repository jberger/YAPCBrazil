require File::Spec;

my (undef, $dir) = app->presentation_file;

app->helper( slurp => sub {
  require Mojo::Util;
  return Mojo::Util::decode('UTF-8', Mojo::Util::slurp($_[1]));
});

my $pres = {
  ppi => File::Spec->catdir($dir, 'code'),
  bootstrap_theme => 1,
  static => File::Spec->catdir($dir, 'public'),
  templates => File::Spec->catdir($dir, 'slides'),
  extra_js  => [
    'myjs.js', 
    # '/MathJax/MathJax.js?config=default',
    'http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=default',
  ],
  extra_css => 'mycss.css',
  finally => sub {
    my $app = shift;
    delete $app->ppi->class_style->{word};
    $app->ppi->class_style->{type} = '#0047FF';
  },
};

$pres->{slides}{list} = [qw/
  title
  sharing
  unshareable_code
  methodology
  problem_scripts
  gain_Mathematica
  cavity
  cavity_perl
  gain_Mathematica
  gain_perl
  example
  methodology_example
  example_simulator
  problem_configuration
  superfish
  Cooke_Mathematica
  uemcolumn
  thanks
/];


$pres;

