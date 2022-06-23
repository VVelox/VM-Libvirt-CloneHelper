package VM::Libvirt::CloneHelper;

use 5.006;
use strict;
use warnings;
use File::Slurp;

=head1 NAME

VM::Libvirt::CloneHelper - The great new VM::Libvirt::CloneHelper!

=head1 VERSION

Version 0.0.1

=cut

our $VERSION = '0.0.1';

=head1 SYNOPSIS

    # initialize it
    my $clone_helper=VM::Libvirt::CloneHelper->new({
        blank_domains=>'/usr/local/etc/libvirt_clonehelper/blank_domains',
        windows_blank=>0,
        mac_base=>'00:08:74:2d:dd:',
        ipv4_base=>'192.168.1.',
        start=>'100',
        to_clone=>'baseVM',
        delete_old=>1,
        clone_name_base=>'foo',
        uuid_auto=>1,
        count=>10,
        verbose=>1,
    });

=head1 METHODS

=head2 new

Initialize the module.

    network=>'default'
    Name of the libvirt network in question.

    blank_domains=>'/usr/local/etc/libvirt_clonehelper/blank_domains',
    List of domains to blank via setting 'dnsmasq:option value='address=/foo.bar/'.
    If not this file does not exist, it will be skipped.

    windows_blank=>0,
    Blank commonly used MS domains.

    mac_base=>'00:08:74:2d:dd:',
    Base to use for the MAC.

    ipv4_base=>'192.168.1.',
    Base to use for the IPs for adding static assignments.

    start=>'100',
    Where to start in 

    to_clone=>'baseVM',
    The name of the VM to clone.

    delete_old=>1,
    If VMs should be deleted if they already exist.
    If not they will be skipped.

    clone_name_base=>'cloneVM',
    Base name to use for creating the clones. 'foo' will become 'foo-$current', so
    for a start of 100, the first one would be 'foo-100' and with a count of 10 the
    last will be 'foo-109'.

    uuid_auto=>1,
    Grab the UUID from the current config.

    count=>10,
    How many clones to create.

=cut

sub new {
	my %args;
	if ( defined( $_[1] ) ) {
		%args = %{ $_[1] };
	}

	my $self = {
		blank_domains   => '/usr/local/etc/libvirt_clonehelper/blank_domains',
		windows_blank   => 0,
		mac_base        => '00:08:74:2d:dd:',
		ipv4_base       => '192.168.1.',
		start           => '100',
		to_clone        => 'baseVM',
		delete_old      => 1,
		clone_name_base => 'foo',
		uuid_auto       => 1,
		count           => 10,
	};
	bless $self;

	# do very basic value sanity checks and reel values in
	my @keys = keys(%args);
	foreach my $key (@keys) {
		if ( $key eq 'mac_base' ) {

			# make sure we got a sane base MAC
			if ( $args{mac_base}
				!~ /^[0-9aAbBcCdDeEfF][0-9aAbBcCdDeEfF]\:[0-9aAbBcCdDeEfF][0-9aAbBcCdDeEfF]\:[0-9aAbBcCdDeEfF][0-9aAbBcCdDeEfF]\:[0-9aAbBcCdDeEfF][0-9aAbBcCdDeEfF]\:[0-9aAbBcCdDeEfF][0-9aAbBcCdDeEfF]\:$/
				)
			{
				die( '"' . $args{mac_base} . '" does not appear to be a valid base for a MAC address' );
			}
		}
		elsif ( $key eq 'ipv4_base' ) {
			# make sure we have a likely sane base for the IPv4 address
			if ( $args{ipv4_base} !~ /^[0-9]+\.[0-9]+\.[0-9]+\.$/ ) {
				die( '"' . $args{ipv4_base} . '" does not appear to be a valid base for a IPv4 address' );
			}
		}
		elsif ( $key eq 'to_clone' ) {
			# make sure we have a likely sane base VM name
			if ( $args{to_clone} !~ /^[A-Za-z0-9\-\.]+$/ ) {
				die( '"' . $args{to_clone} . '" does not appear to be a valid VM name' );
			}
		}
		elsif ( $key eq 'clone_name_base' ) {
			# make sure we have a likely sane base name to use for creating clones
			if ( $args{clone_name_base} !~ /^[A-Za-z0-9\-\.]+$/ ) {
				die( '"' . $args{clone_name_base} . '" does not appear to be a valid VM name' );
			}
		}

		# likely good, adding
		$self->{$key} = $args{$key};
	}

	return $self;
}

=head2 delete_clones

Delete all the clones

    $clone_helper->delete_clones;

=cut

sub delete_clones{
	my $self=$_[0];

	# virsh undefine --snapshots-metadata
	# the VM under /var/lib/libvirt/images needs to be removed manually given
	# the shit show that is libvirt does not have a means of sanely removing
	# VMs and relevant storage... for example it will include ISOs in relevant
	# VMs to be removed if you let it... and it is likely to fail to remove the
	# base disk image for a VM, even if you pass it any/every combination of
	# possible flags...

	
}

=head1 AUTHOR

Zane C. Bowers-Hadley, C<< <vvelox at vvelox.net> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-vm-libvirt-clonehelper at rt.cpan.org>, or through
the web interface at L<https://rt.cpan.org/NoAuth/ReportBug.html?Queue=VM-Libvirt-CloneHelper>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc VM::Libvirt::CloneHelper


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<https://rt.cpan.org/NoAuth/Bugs.html?Dist=VM-Libvirt-CloneHelper>

=item * CPAN Ratings

L<https://cpanratings.perl.org/d/VM-Libvirt-CloneHelper>

=item * Search CPAN

L<https://metacpan.org/release/VM-Libvirt-CloneHelper>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2022 by Zane C. Bowers-Hadley.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)


=cut

1;    # End of VM::Libvirt::CloneHelper
