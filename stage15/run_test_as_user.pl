#!/usr/bin/perl
use strict;

my $orig_test = "dan_test_dev_as_user";
my $account_name = "default-qa-account";
my $user_name = "user00";

if( @ARGV > 0 ){
	$orig_test = shift @ARGV;
};

if( @ARGV > 0 ){
	$account_name = shift @ARGV
};

if( @ARGV > 0 ){
	$user_name = shift @ARGV
};


print "\n";
print "Run the Test as User\n";
print "\n";
print "[TEST]\t$orig_test\n";
print "[ACCOUNT NAME]\t$account_name\n";
print "[USER NAME]\t$user_name\n";
print "[REPEAT LIMIT]\t$ENV{'TEST_REPEAT_LIMIT'}\n";
print "\n";


if(  -e "../etc/runs/logs" ){
	system("rm -fr ../etc/runs/logs");	
}; 

system("mkdir -p ../etc/runs/logs");	

print "\n";

my $testname = $orig_test . "_user_" . $user_name;
	
print "\n";
print "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
print "Running the Test \'$testname\' for Account \'$account_name\' and User \'$user_name\'\n";
print "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
print "\n";
print "\n";
print "\n";

if( run_test_as_user($testname) ){
	print "[TEST_REPORT]\tFAILED in running test \'$testname\' !!\n\n";
	exit(1);
};

print "\n";
print "\n";		
print "\n";
print "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
print "End of the Test \'$testname\' for Account \'$account_name\' and User \'$user_name\'\n";
print "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
print "\n";

print "\n";
print "\n";
print "[TEST_REPORT]\tCompleted Run Test as User\n";
print "\n";


exit(0);



######################### SUB-ROUTINES #################################


sub run_test_as_user{

	my $testname = shift @_;

	if( !( -e "../etc/runs/$testname") ){
		print "[TEST_REPORT]\tFAILED in locating $testname !!\n\n";
		return 1;
	}; 

	if( !( -e "../etc/runs/logs") ){
		print "[TEST_REPORT]\tFAILED in locating ../etc/runs/logs !!\n\n";
		return 1;
	}; 

	my $this_log_file = $testname .".log";

	system("rm -f ../etc/runs/logs/$this_log_file"); 
	system("touch ../etc/runs/logs/$this_log_file"); 

	system("cd ../etc/runs/$testname; perl ./run_test.pl ".$testname.".conf > ../logs/$this_log_file 2> ../logs/$this_log_file");
	
	return 0;
};


# To make 'sed' command human-readable
# my_sed( target_text, new_text, filename);
#   --->
#        sed --in-place 's/ <target_text> / <new_text> /' <filename>
sub my_sed{

        my ($from, $to, $file) = @_;

        $from =~ s/([\'\"\/])/\\$1/g;
        $to =~ s/([\'\"\/])/\\$1/g;

        my $cmd = "sed --in-place 's/" . $from . "/" . $to . "/' " . $file;

        system("$cmd");

        return 0;
};

1;

