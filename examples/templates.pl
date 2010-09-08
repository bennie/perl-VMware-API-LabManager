#!/usr/bin/perl

use Data::Dumper;
use VMware::API::LabManager;
use strict;

my $version = ( split ' ', '$Revision: 1.1 $' )[1];

### Configuration

#my $username  = 'sbo-migration';
#my $password  = 'welcome1';
#my $server    = '10.198.138.73';

my $username  = 'migration';
my $password  = 'welcome1';
my $server    = '10.207.251.54';

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

my %dp;

for my $org (@$orgs) {
  my $this_orgname = $org->{Name};
  print "\nORG: $this_orgname\n";

  my $this_labman = new VMware::API::LabManager (
    $username,        # Username
    $password,        # Password
    $server,          # Server
    $this_orgname,    # Org Name
    $workspace        # Workspace Name
  );

  my $templates = $this_labman->priv_ListTemplates();

  for my $template (@$templates) {
    #next unless $template->{name} =~ /selen/i;
    print "  $template->{name} ($template->{id})\n";
    $dp{$this_orgname}{$template->{name}}++;
  }
}

my $allcount = scalar( @$orgs ) - 1;

my %counts;

for my $template ( keys %{$dp{Global}} ) {
  my $appearence = 0;

  for my $org ( keys %dp ) {
    next if $org eq 'Global';
    $appearence++ if defined $dp{$org}{$template};
  }


  $appearence = 'ALL' if $appearence == $allcount;

  $counts{$appearence}++;

  #next if $appearence eq 'ALL';
  #next if $appearence == 1;
  #next if $appearence == 0;
  #print "$template : $appearence\n";

}

for my $count ( sort keys %counts ) {
  print "$count : $counts{$count}\n";
}
