#!/usr/bin/perl

use Data::Dumper;
use VMware::API::LabManager;
use strict;

my $version = ( split ' ', '$Revision: 1.1 $' )[1];

### Configuration

my $username  = 'sbo-migration';
my $password  = 'welcome1';
my $server    = '10.198.138.73'; # Target

my $orgname   = 'Global';
my $workspace = 'Main';

my $labman = new VMware::API::LabManager (
  $username,        # Username
  $password,        # Password
  $server,          # Server
  $orgname,         # Org Name
  $workspace        # Workspace Name
);

my $configs = $labman->GetConfigurationByName('vmware-testrun2-01');
my $config = $configs->[0];

my $machines = $labman->ListMachines($config->{id});
my $machine = $machines->[0];

my $machine_id = $machines;

print "Upgrading hardware for $machine->{id}\n";

my $ret = $labman->priv_MachineUpgradeVirtualHardware( $machine->{id} );

print Dumper($ret);
