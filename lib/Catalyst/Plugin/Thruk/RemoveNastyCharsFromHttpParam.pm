package Catalyst::Plugin::Thruk::RemoveNastyCharsFromHttpParam;
use parent 'Class::Data::Inheritable';

use strict;

use Carp;

our $VERSION = 1.0;

# Note we have to hook here as uploads also add to the request parameters
sub prepare_uploads {
    my($c) = @_;

    $c->next::method(@_);

    for my $key ( keys %{ $c->request->{'parameters'} } ) {
        next if $key eq 'data';
        next if $key eq 'referer';
        next if $key eq 'selected_hosts';
        next if $key eq 'selected_services';
        next if $key eq 'service';
        next if $key eq 'conf_comment';
        next if $key eq 'content';
        next if $key eq 'filter';
        next if $key eq 'performance_data';
        next if $key eq 'password';
        next if $key eq 'types';
        next if $key =~ /^s\d+_op/mxo;
        next if $key =~ /^s\d+_value/mxo;
        next if $key =~ /^\w{3}_s\d+_value/mxo;
        next if $key =~ /^\w{3}_s\d+_op/mxo;
        next if $key =~ /^data\./mxo;
        next if $key =~ /^obj\./mxo;
        next if $key =~ /pattern/mx;
        next if $key =~ /exclude/mxo;
        next if $key =~ /^tabpan/mxo;
        my $value = $c->request->{'parameters'}->{$key};
        if ( ref $value && ref $value ne 'ARRAY' ) {
            next;
        }
        for ( ref($value) ? @{$c->request->{'parameters'}->{$key}} : $c->request->{'parameters'}->{$key} ) {
            $_ =~ s/[;\|<>]+//gmx if defined $_;
        }
    }
    return;
}

1;

__END__

=head1 NAME

Catalyst::Plugin::Thruk::RemoveNastyCharsFromHttpParam - Remove some chars from variables

=head1 SYNOPSIS

    use Catalyst qw[Thruk::RemoveNastyCharsFromHttpParam];


=head1 DESCRIPTION

On request, remove some chars from all params.

=head1 OVERLOADED METHODS

=over

=item prepare_uploads

Remove some nasty characters from all input parameters

=back

=head1 SEE ALSO

L<Catalyst>.

=head1 AUTHORS

Sven Nierlein, 2009-2014, <sven@nierlein.org>

=head1 LICENSE

This library is free software . You can redistribute it and/or modify
it under the same terms as perl itself.

=cut
