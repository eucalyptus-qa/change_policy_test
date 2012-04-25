#!/usr/bin/perl

use strict;

sub list_all_accounts_given_account_and_user{
	my $account = shift @_;
	my $user = shift @_;

	print "\n";
	print "########################### LIST-ALL-ACCOUNTS-GIVEN-ACCOUNT-AND-USER ##############################\n";

	### get all accounts given account and user
	print "$ENV{'QA_CLC_IP'} :: euare-accountlist\n";
	my $out = `ssh -o ServerAliveInterval=1 -o ServerAliveCountMax=5 -o StrictHostKeyChecking=no root\@$ENV{'QA_CLC_IP'} \"source /root/cred_depot/$account/$user/eucarc; euare-accountlist\"`;
	print "\n";

	return $out
};



sub list_all_users_given_account_and_user{
	my $account = shift @_;
	my $user = shift @_;

	print "\n";
	print "########################### LIST-ALL-USERS-GIVEN-ACCOUNT-AND-USER ##############################\n";

	### get all users given account and user
	print "$ENV{'QA_CLC_IP'} :: euare-userlistbypath\n";
	my $out = `ssh -o ServerAliveInterval=1 -o ServerAliveCountMax=5 -o StrictHostKeyChecking=no root\@$ENV{'QA_CLC_IP'} \"source /root/cred_depot/$account/$user/eucarc; euare-userlistbypath\"`;
	print "\n";

	return $out
};


sub list_all_groups_given_account_and_user{
	my $account = shift @_;
	my $user = shift @_;

	print "\n";
	print "########################### LIST-ALL-GROUPS-GIVEN-ACCOUNT-AND-USER ##############################\n";

	### get all groups given account and user
	print "$ENV{'QA_CLC_IP'} :: euare-grouplistbypath\n";
	my $out = `ssh -o ServerAliveInterval=1 -o ServerAliveCountMax=5 -o StrictHostKeyChecking=no root\@$ENV{'QA_CLC_IP'} \"source /root/cred_depot/$account/$user/eucarc; euare-grouplistbypath\"`;
	print "\n";

	return $out
};


sub list_all_account_policies_given_account_and_user_and_target_account{
	my $account = shift @_;
	my $user = shift @_;
	my $target_account = shift @_;

	print "\n";
	print "########################### LIST-ALL-ACCOUNT-POLICIES-GIVEN-ACCOUNT-AND-USER ##############################\n";

	print "$ENV{'QA_CLC_IP'} :: euare-accountlistpolicies -a $target_account\n";
	my $out = `ssh -o ServerAliveInterval=1 -o ServerAliveCountMax=5 -o StrictHostKeyChecking=no root\@$ENV{'QA_CLC_IP'} \"source /root/cred_depot/$account/$user/eucarc; euare-accountlistpolicies -a $target_account\"`;
	print "\n";

	return $out
};

sub list_all_group_policies_given_account_and_user_and_target_group{
	my $account = shift @_;
	my $user = shift @_;
	my $target_group = shift @_;

	print "\n";
	print "########################### LIST-ALL-GROUP-POLICIES-GIVEN-ACCOUNT-AND-USER ##############################\n";

	print "$ENV{'QA_CLC_IP'} :: euare-grouplistpolicies -g $target_group\n";
	my $out = `ssh -o ServerAliveInterval=1 -o ServerAliveCountMax=5 -o StrictHostKeyChecking=no root\@$ENV{'QA_CLC_IP'} \"source /root/cred_depot/$account/$user/eucarc; euare-grouplistpolicies -g $target_group\"`;
	print "\n";

	return $out
};

sub list_all_user_policies_given_account_and_user_and_target_user{
	my $account = shift @_;
	my $user = shift @_;
	my $target_user = shift @_;

	print "\n";
	print "########################### LIST-ALL-USER-POLICIES-GIVEN-ACCOUNT-AND-USER ##############################\n";

	print "$ENV{'QA_CLC_IP'} :: euare-userlistpolicies -u $target_user\n";
	my $out = `ssh -o ServerAliveInterval=1 -o ServerAliveCountMax=5 -o StrictHostKeyChecking=no root\@$ENV{'QA_CLC_IP'} \"source /root/cred_depot/$account/$user/eucarc; euare-userlistpolicies -u $target_user\"`;
	print "\n";

	return $out
};

sub list_all_users_in_group_given_account_and_user_and_target_group{
	my $account = shift @_;
	my $user = shift @_;
	my $target_group = shift @_;

	print "\n";
	print "########################### LIST-ALL-USERS-IN-GROUP-GIVEN-ACCOUNT-AND-USER ##############################\n";

	print "$ENV{'QA_CLC_IP'} :: euare-grouplistusers -g $target_group\n";
	my $out = `ssh -o ServerAliveInterval=1 -o ServerAliveCountMax=5 -o StrictHostKeyChecking=no root\@$ENV{'QA_CLC_IP'} \"source /root/cred_depot/$account/$user/eucarc; euare-grouplistusers -g $target_group\"`;
	print "\n";

	return $out
};

sub list_all_groups_in_user_given_account_and_user_and_target_user{
	my $account = shift @_;
	my $user = shift @_;
	my $target_user = shift @_;

	print "\n";
	print "########################### LIST-ALL-GROUPS-IN-USER-GIVEN-ACCOUNT-AND-USER ##############################\n";

	print "$ENV{'QA_CLC_IP'} :: euare-userlistgroups -u $target_user\n";
	my $out = `ssh -o ServerAliveInterval=1 -o ServerAliveCountMax=5 -o StrictHostKeyChecking=no root\@$ENV{'QA_CLC_IP'} \"source /root/cred_depot/$account/$user/eucarc; euare-userlistgroups -u $target_user\"`;
	print "\n";

	return $out
};




1;

