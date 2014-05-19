# SMB-Perl library, Copyright (C) 2014 Mikhael Goikhman, migo@cpan.org
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

use strict;
use warnings;

package SMB::v2::Command;

use parent 'SMB::Command';

use SMB::v2::Header;

sub new ($$%) {
	my $class = shift;
	my $header = shift;
	my %options = @_;

	die "Invalid sub-class $class, should be SMB::v2::Command::*"
		unless $class =~ /^SMB::v2::Command::(\w+)/;

	die "Invalid header $header, should be isa SMB::v2::Header"
		unless $header && $header->isa('SMB::v2::Header');

	my $self = $class->SUPER::new(
		2, $1, $header,
		%options,
	);

	return $self;
}

sub is_response ($) {
	my $self = shift;

	return $self->header->{flags} & SMB::v2::Header::FLAGS_RESPONSE ? 1 : 0;
}

1;
