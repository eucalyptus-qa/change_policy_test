#!/usr/bin/perl


sub set_account_user_policy{
	my $account = shift @_;
	my $user = shift @_;
	my $policy = shift @_;

	print "\n";
	print "########################### SET-ACCOUNT-USER-POLICY ##############################\n";

	### set account user policy
	print "$ENV{'QA_CLC_IP'} :: euare-useruploadpolicy -u $user -p $policy -f $policy\n";
	system("ssh -o ServerAliveInterval=1 -o ServerAliveCountMax=5 -o StrictHostKeyChecking=no root\@$ENV{'QA_CLC_IP'} \"source /root/cred_depot/$account/admin/eucarc; euare-useruploadpolicy -u $user -p $policy -f $policy\" ");
	print "\n";
	sleep(2);

	print "\n";
	print "########################### VERIFY-ACCOUNT-USER-POLICY ##############################\n";

	### verify account group policy via 'euare-userlistpolicies -g'
	print "$ENV{'QA_CLC_IP'} :: euare-userlistpolicies -u $user\n";
	my $out = `ssh -o ServerAliveInterval=1 -o ServerAliveCountMax=5 -o StrictHostKeyChecking=no root\@$ENV{'QA_CLC_IP'} \"source /root/cred_depot/$account/admin/eucarc; euare-userlistpolicies -u $user\"`;
	print "\n";
	print "$out\n";
	if( !($out =~ /$policy/) ){
		print "[TEST_REPORT]\tFAILED in setting policy $policy to user $user\n\n";
	};
	print "[TEST_REPORT]\tSucceeded in setting policy $policy to user $user\n\n";

	return 0;
};


1;

