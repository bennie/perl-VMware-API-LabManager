#!/usr/bin/perl

use Data::Dumper;
use Getopt::Long;
use VMware::API::LabManager;
use strict;

my $version = ( split ' ', '$Revision: 1.2 $' )[1];

### Configuration

my $username  = 'ppollard';
my $password  = 'z2A3p464';
my $orgname   = 'Global';
my $workspace = 'Main';
my $server    = '10.198.138.73'; # Source

my $labman = new VMware::API::LabManager (
  $username,        # Username
  $password,        # Password
  $server,          # Server
  $orgname,         # Org Name
  $workspace        # Workspace Name
);

my %netmap = (
  DHCP             => 2,
  STATIC_AUTOMATIC => 2,
);

my $net_id = 2;


my $configs = $labman->ListConfigurations(1);

for my $config (@$configs) {
  my $configid = $config->{id};
  &fix_network($configid);
}


sub fix_network {
  my $id = shift @_;
  print "Fixing network for the machines in config $id\n";

  my $machines = $labman->ListMachines($id);
  for my $machine (@$machines) {
    print "Fixing nics on machine $machine->{name} ($machine->{id})\n";

    my $networks = $labman->priv_GetNetworkInfo($machine->{id});
    my $count = scalar(@$networks);
    print "$machine->{name}: found $count networks\n";

    my @network_types;

    for my $nic (@$networks) {
      print "$machine->{name}: NIC $nic->{nicId} is of type $nic->{ipAddressingMode}\n";
      push @network_types, $nic->{ipAddressingMode};
      print "$machine->{name}: Removing NIC $nic->{nicId}\n";
      my $ret = $labman->priv_NetworkInterfaceDelete($machine->{id},$netinf->{nicId});
      warn $ret if $ret;
    }

    for my $type (@network_types) {
      print "$machine->{name}: Adding NIC of type $type\n";
      my $ret = $labman->priv_NetworkInterfaceCreate( $machine->{id}, $net_id, $type, undef );
      warn $ret unless $ret =~ /^\d+$/;
      print "$machine->{name}: NIC $ret created.\n";
    }
  }
}
