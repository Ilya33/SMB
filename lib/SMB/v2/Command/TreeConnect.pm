# SMB Perl library, Copyright (C) 2014 Mikhael Goikhman, migo@cpan.org
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

package SMB::v2::Command::TreeConnect;

use strict;
use warnings;

use parent 'SMB::v2::Command';

sub init ($) {
	$_[0]->set(
		share_type   => 1,
		share_flags  => 0x800,
		capabilities => 0,
		access_mask  => 0x1f01ff,
	)
}

sub set_uri ($$) {
	my $self = shift;
	my $uri = shift;

	$self->{uri} = $uri;

	return $self;
}

sub get_uri ($) {
	my $self = shift;

	my $uri = $self->{uri}
		or die "No share uri set for TreeConnect";
	$uri =~ m~([/\\])\1([\w.]+(?::\d+)?)\1([!/\\]+)\1?~
		or die "Invalid share uri ($uri) for TreeConnect";

	return $uri;
}

sub parse ($$) {
	my $self = shift;
	my $parser = shift;

	return $self;
}

sub prepare_response ($) {
	my $self = shift;

	$self->SUPER::prepare_response;
}

sub pack ($$) {
	my $self = shift;
	my $packer = shift;

	if ($self->is_response) {
		$packer
			->uint8($self->share_type)
			->uint8(0)  # reserved
			->uint32($self->share_flags)
			->uint32($self->capabilities)
			->uint32($self->access_mask)
		;
	} else {
		$packer
			->uint16(0)  # reserved
			->uint16($packer->diff('smb-header') + 4)
			->stub('uri-len', 'uint16')
			->mark('uri')
			->utf16($self->get_uri)
			->fill('uri-len', $packer->diff('uri'))
		;
	}
}

1;