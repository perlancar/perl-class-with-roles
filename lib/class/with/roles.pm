package class::with::roles;

# AUTHORITY
# DATE
# DIST
# VERSION

use strict 'subs', 'vars';
use warnings;

sub import {
    my $package = shift;

    my $class = shift;
    my @class_import_args;
    while (@_) {
        last unless $_[0] =~ /\A\+./;
        push @class_import_args, shift;
    }
    (my $class_pm = "$class.pm") =~ s!::!/!g;
    require $class_pm;
    $class_pm->import(@_);

    my @roles;
    while (@_) {
        # when there is support for parameterized roles, we'll allow this:
        # "+My::Role1", "import1", "import2", "+My::Role2", "import-for-role2",
        # "another", ...
        $_[0] =~ /\A\+(.+)\z/
            or die "Please specify role with +Role::Name syntax";
        push @roles, $1;
        shift;
    }
    if (@roles) {
        require Role::Tiny;
        Role::Tiny->apply_roles_to_package($class, @roles);
    }
}

1;
# ABSTRACT: Shortcut for using a class and applying it some Role::Tiny roles, from the command line

=head1 SYNOPSIS

Use mainly for the command line:

 % perl -Mclass::with::roles=MyClass,+My::Role1,+My::Role2 -E'...'
 % perl -Mclass::with::roles=MyClass,import1,import2,+My::Role1,+My::Role2 -E'...'

which is shortcut for:

 % perl -E'use MyClass;                      use Role::Tiny; Role::Tiny->apply_roles_to_package("MyClass", "My::Role1", "My::Role2"); ...'
 % perl -E'use MyClass "import1", "import2"; use Role::Tiny; Role::Tiny->apply_roles_to_package("MyClass", "My::Role1", "My::Role2"); ...'

but you can also use it from regular Perl code:

 use class::with::roles MyClass => '+My::Role1', '+My::Role2';
 use class::with::roles MyClass => 'import1', 'import2', '+My::Role1', '+My::Role2';


=head1 DESCRIPTION


=head1 SEE ALSO

L<Role::Tiny>
