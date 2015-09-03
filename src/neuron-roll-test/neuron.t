#!/usr/bin/perl -w
# neuron roll installation test.  Usage:
# neuron.t [nodetype]
#   where nodetype is one of "Compute", "Dbnode", "Frontend" or "Login"
#   if not specified, the test assumes either Compute or Frontend

use Test::More qw(no_plan);

my $appliance = $#ARGV >= 0 ? $ARGV[0] :
                -d '/export/rocks/install' ? 'Frontend' : 'Compute';
my $installedOnAppliancesPattern = '.';
my $isInstalled = -d '/opt/neuron';
my $output;

my $TESTFILE = 'tmpneuron';

# neuron-common.xml
if($appliance =~ /$installedOnAppliancesPattern/) {
  ok($isInstalled, "neuron installed");
} else {
  ok(! $isInstalled, "neuron not installed");
}

# from http://www.neuron.yale.edu/hg/nrntest/ivoc/Matrix/fprint.hoc
open(OUT, ">$TESTFILE.hoc");
print OUT <<END;
objref m,m2, f
m = new Matrix(3,4)
for i=0,m.nrow-1 for j=0,m.ncol-1 m.x[i][j] = 10*i + j
f = new File()
f.wopen("$TESTFILE.dat")
m.fprint(f)
f.close()
f.ropen("$TESTFILE.dat")
m2 = new Matrix()
m2.scanf(f)
f.close()
m2.printf
f.wopen("$TESTFILE.dat")
m.fprint(0, f)
f.close()
m2 = new Matrix()
f.ropen("$TESTFILE.dat")
m2.scanf(f, 4, 3)
f.close()
m2.printf()
END
close(OUT);

SKIP: {

  skip 'neuron not installed', 4 if ! $isInstalled;
  $output = `module load neuron; nrniv -nogui -nobanner $TESTFILE.hoc 2>&1`;
  like($output, qr/ 3\s+10\s+11/, 'neuron test run');
  `/bin/ls /opt/modulefiles/applications/neuron/[0-9]* 2>&1`;
  ok($? == 0, 'neuron module installed');
  `/bin/ls /opt/modulefiles/applications/neuron/.version.[0-9]* 2>&1`;
  ok($? == 0, 'neuron version module installed');
  ok(-l '/opt/modulefiles/applications/neuron/.version',
     'neuron version module link created');

}

`rm -fr $TESTFILE*`;
