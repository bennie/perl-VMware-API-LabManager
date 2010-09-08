#!/usr/bin/perl

use Data::Dumper;
use VMware::API::LabManager;
use strict;

my $version = ( split ' ', '$Revision: 1.1 $' )[1];

### Configuration

my $username  = 'migration';
my $password  = 'welcome1';
my $server    = '10.207.251.54'; # Prod source

my $orgname   = 'Global';
my $workspace = 'Main';

my $labman = new VMware::API::LabManager (
  $username,        # Username
  $password,        # Password
  $server,          # Server
  $orgname,         # Org Name
  $workspace        # Workspace Name
);

my $orgs = $labman->priv_GetOrganizations();

for my $org (@$orgs) {
  my $org_id = $org->{Id};
  my $org_name = $org->{Name};
  print "ORG: $org_name ($org_id)\n";

  my $wss = $labman->priv_GetOrganizationWorkspaces($org_id);
  $wss = [ $wss ] if ref $wss eq 'HASH'; # Single workspace condition

  for my $ws (@$wss) {
    my $ws_id = $ws->{Id};
    my $ws_name = $ws->{Name};
    print "  WS: $ws_name ($ws_id)\n";

    if ( $ws->{Configurations} and $ws->{Configurations}->{Configuration} ) {
      my $confs = $ws->{Configurations}->{Configuration};
      $confs = [ $confs ] if ref $confs eq 'HASH'; # Single configuration condition
      for my $conf (@$confs) {
        my $conf_id = $conf->{id};
        my $conf_name = $conf->{name};
        print "    CONF: $conf_name ($conf_id)\n";
      }
    }
  }
  print "\n";
}
