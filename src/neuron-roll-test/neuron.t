#!/usr/bin/perl -w
# neuron roll installation test.  Usage:
# neuron.t [nodetype]
#   where nodetype is one of "Compute", "Dbnode", "Frontend" or "Login"
#   if not specified, the test assumes either Compute or Frontend

use Test::More qw(no_plan);

my $appliance = $#ARGV >= 0 ? $ARGV[0] :
                -d '/export/rocks/install' ? 'Frontend' : 'Compute';
my $installedOnAppliancesPattern = 'Compute';
my $output;
my $TESTFILE = 'tmpneuron';

# neuron_doc.xml
if ($appliance eq 'Frontend') {
  ok(-d '/var/www/html/roll-documentation/6.1/neuron', 'doc installed');
} else {
  ok(! -d '/var/www/html/roll-documentation/6.1/neuron', 'doc not installed');
}

# neuron-install.xml
if($appliance =~ /$installedOnAppliancesPattern/) {
  ok(-d "/opt/neuron", "neuron installed");
} else {
  ok(! -d "/opt/neuron", "neuron not installed");
}

SKIP: {

  `mkdir $TESTFILE.dir`;
  skip 'neuron not installed', 1 if ! -d "/opt/neuron";
  open(OUT, ">$TESTFILE.sh");
  print OUT <<END;
if test -f /etc/profile.d/modules.sh; then
  . /etc/profile.d/modules.sh
  module load neuron
  cd $TESTFILE.dir
  hg clone http://www.neuron.yale.edu/hg/nrntest 
  cd nrntest
  neurondemo <<EOF

EOF
  sh testutil/clean
  sh runtests
fi
END
  close(OUT);
  `/bin/bash $TESTFILE.sh >& .o`;
  ok(`grep -c succeed .o` >= 48, 'neuron works');
  `rm -rf $TESTFILE.dir`;
}


SKIP: {

  skip 'neuron not installed', 1
    if $appliance !~ /$installedOnAppliancesPattern/;
  skip 'modules not installed', 1 if ! -f '/etc/profile.d/modules.sh';
    my ($noVersion) = "neuron" =~ m#([^/]+)#;
    `/bin/ls /opt/modulefiles/applications/$noVersion/[0-9]* 2>&1`;
    ok($? == 0, "neuron module installed");
    `/bin/ls /opt/modulefiles/applications/$noVersion/.version.[0-9]* 2>&1`;
    ok($? == 0, "neuron version module installed");
    ok(-l "/opt/modulefiles/applications/$noVersion/.version",
       "neuron version module link created");
}

`rm -fr .o $TESTFILE*`;
