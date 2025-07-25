requires 'perl', '5.38.0';
requires 'Mojolicious';
requires 'Mojo::Pg';
requires 'DBI';
requires 'aliased';
requires 'Sub::Name';
requires 'File::Slurp';
requires 'Scope::Guard';
requires 'DBIx::Class';
requires 'DBIx::Class::Schema::Loader';
requires 'Mojolicious::Plugin::OpenAPI';

on 'test' => sub {
  requires 'Test::More';
  requires 'Test::Mojo::WithRoles';
  requires 'Test::Mojo::Role::Debug';
  requires 'Test::Class';
};
