#! /usr/bin/perl

# fulldex.pl - Invoked by the main page of the liturgy resource - assures that all the individual pages are generated, and outputs the references to them for the main page.
# Copyright (C) 2024  Sophia Elizabeth Shapira
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

use strict;
use Date::Calc;

my @curdate;
my $vari_counto;
my $vari_maxo;
my $not_first_rodeo = 0;
my $valid_day_prv = 'no';
my $valid_day_nex = 'no';

my @week_nom_full = (
  'Sunday','Monday','Tuesday','Wednesday','Thursday',
  'Friday','Saturday','Sunday'
);

my @week_nom_abr = (
  'Sun','Mon','Tue','Wed','Thu',
  'Fri','Sat','Sun'
);

my @month_nom_abr = ( 'x'
  , 'Jan' , 'Feb' , 'Mar'
  , 'Apr' , 'May' , 'Jun'
  , 'Jul' , 'Aug' , 'Sep'
  , 'Oct' , 'Nov' , 'Dec'
);

my @month_nom_full = ( 'x'
  , 'January' , 'February' , 'March'
  , 'April' , 'May' , 'June'
  , 'July' , 'August' , 'September'
  , 'October' , 'November' , 'December'
);

sub addzer
{
  my $lc_zra;
  my $lc_src;
  my $lc_ret;
  ($lc_zra,$lc_src) = @_;
  $lc_ret = '';
  
  while ( $lc_zra > 0.5 )
  {
    my $lc2_cr;
    $lc_src = "00$lc_src";
    $lc2_cr = chop($lc_src);
    $lc_ret = $lc2_cr . $lc_ret;
    $lc_zra = int($lc_zra - 0.8);
  }
  return $lc_ret;
}


# HERE WE SET THE DEFAULTS OF THE DATE RANGE:
@curdate = &Date::Calc::Today();
$vari_counto = -2;
$vari_maxo = 20;

# AND HERE WE SET THE BASIC ALTERATIONS:
{
  my $lc_mode;
  $lc_mode = $ENV{'X_MODE_TYPE'};
  
  if ( $lc_mode eq 'stable' )
  {
    my $lc2_cm;
    $lc2_cm = 'liturgscr-lookup';
    #$lc2_cm .= ' "${X_RES_BASE}/lcconf/resources.cnf"';
    $lc2_cm .= ' "${X_RES_BASE}/lcconf/prefs.cnf"';
    $lc2_cm .= ' daysinset';
    $vari_maxo = `$lc2_cm`; chomp($vari_maxo);
    if ( $vari_maxo eq '' ) { $vari_maxo = 5; }
  }
  
  if ( $lc_mode eq 'month' )
  {
    @curdate = ($ENV{'X_MODE_S_YEAR'},$ENV{'X_MODE_S_MONTH'},1);
    $vari_counto = 0;
    $vari_maxo = &Date::Calc::Days_in_Month($curdate[0],$curdate[1]);
  }
}

while ( $vari_counto < ( $vari_maxo - 0.5 ) )
{
  my @lc_tdate;
  my $lc_daycod;
  my $lc_dayow_a;
  my $lc_dayow_b;
  my $lc_dayow_c;
  
  my @lc_date_prv;
  my @lc_date_nex;
  my $lc_month_prv;
  my $lc_month_nex;
  my $lc_month_c_prv;
  my $lc_month_c_nex;
  my $lc_day_c_prv;
  my $lc_day_c_nex;
  
  @lc_tdate = &Date::Calc::Add_Delta_Days(@curdate,$vari_counto);
  $lc_dayow_a = &Date::Calc::Day_of_Week(@lc_tdate);
  $lc_dayow_b = $week_nom_full[$lc_dayow_a];
  $lc_dayow_c = $week_nom_abr[$lc_dayow_a];
  
  @lc_date_prv = &Date::Calc::Add_Delta_Days(@lc_tdate,-1);
  @lc_date_nex = &Date::Calc::Add_Delta_Days(@lc_tdate,1);
  $lc_month_prv = @lc_date_prv[1];
  $lc_month_nex = @lc_date_nex[1];
  $lc_month_c_prv = $month_nom_abr[$lc_month_prv];
  $lc_month_c_nex = $month_nom_abr[$lc_month_nex];
  
  $lc_daycod = &addzer(4,$lc_tdate[0]) . '-' . &addzer(2,$lc_tdate[1]) . '-' . &addzer(2,$lc_tdate[2]);
  
  $lc_day_c_prv = &addzer(4,$lc_date_prv[0]) . '-' . &addzer(2,$lc_date_prv[1]) . '-' . &addzer(2,$lc_date_prv[2]);
  $lc_day_c_nex = &addzer(4,$lc_date_nex[0]) . '-' . &addzer(2,$lc_date_nex[1]) . '-' . &addzer(2,$lc_date_nex[2]);
  
  $ENV{'X_PRV_DATE'} = $lc_day_c_prv;
  $ENV{'X_NEX_DATE'} = $lc_day_c_nex;
  $ENV{'X_PRV_MONTH'} = $lc_month_c_prv;
  $ENV{'X_NEX_MONTH'} = $lc_month_c_nex;
  $ENV{'X_PRV_DAYOM'} = $lc_date_prv[2];
  $ENV{'X_NEX_DAYOM'} = $lc_date_nex[2];
  
  $valid_day_nex = 'yes';
  if ( $vari_counto > ( $vari_maxo - 1.5 ) ) { $valid_day_nex = 'no'; }
  $ENV{'X_PRV_GO'} = $valid_day_prv;
  $ENV{'X_NEX_GO'} = $valid_day_nex;
  $valid_day_prv = 'yes';
  
  #print STDERR $lc_day_c_prv . " -- " . $lc_day_c_nex . ' -- ' . $valid_day_nex . "\n";
  
  $ENV{"X_T_YEAR"} = $lc_tdate[0];
  $ENV{"X_T_MONTH"} = $lc_tdate[1];
  $ENV{"X_T_DAYOM"} = $lc_tdate[2];
  $ENV{"X_T_DAYCODE"} = $lc_daycod;
  $ENV{'X_T_DAYOW_FL'} = $lc_dayow_b;
  $ENV{'X_T_DAYOW_AB'} = $lc_dayow_c;
  $ENV{'X_T_NMONTH_AB'} = $month_nom_abr[$lc_tdate[1]];
  $ENV{'X_T_NMONTH_FL'} = $month_nom_full[$lc_tdate[1]];
  
  # THE FOLLOWING BLOCK IS WHERE VARI-COUNTO
  # FINALLY GETS INCREMENTED:
  {
    my $lc2_a;
    $lc2_a = $vari_counto;
    if ( $lc2_a < ( 0 - 0.5 ) )
    {
      $vari_counto = int($lc2_a + 0.8);
    } else {
      $vari_counto = int($lc2_a + 1.2);
    }
    if ( $lc2_a == $vari_counto ) { $vari_counto = int($lc2_a + 1.2); }
  }
  
  #print STDERR "Doing Another Day: DEBUG:\n";
  
  system("liturgscr-gener -scf scrip/daily-main.skd -date " . $lc_tdate[0] . ' ' . $lc_tdate[1] . ' ' . $lc_tdate[2] . " > \${X_DESTIN_DIR}/pz-" . $lc_daycod . "-main.html");
  
  #system("liturgscr-gener -scf scrip/daily-h03.skd -date " . $lc_tdate[0] . ' ' . $lc_tdate[1] . ' ' . $lc_tdate[2] . " > \${X_DESTIN_DIR}/pz-" . $lc_daycod . "-h03.html");
  
  #system("liturgscr-gener -scf scrip/daily-h04.skd -date " . $lc_tdate[0] . ' ' . $lc_tdate[1] . ' ' . $lc_tdate[2] . " > \${X_DESTIN_DIR}/pz-" . $lc_daycod . "-h04.html");
  
  #system("liturgscr-gener -scf scrip/daily-h05.skd -date " . $lc_tdate[0] . ' ' . $lc_tdate[1] . ' ' . $lc_tdate[2] . " > \${X_DESTIN_DIR}/pz-" . $lc_daycod . "-h05.html");
  
  
  
  if ( $not_first_rodeo > 5 )
  {
    if ( ( $lc_dayow_a == 1 ) | ( $lc_dayow_a == 6 ) )
    {system ("liturgscr-gener","-scf","scrip/item-dx-sep.skd","-date",$lc_tdate[0],$lc_tdate[1],$lc_tdate[2]);
    }
  }
  $not_first_rodeo = 10;
  
  
  system ("liturgscr-gener","-scf","scrip/item-dx.skd","-date",$lc_tdate[0],$lc_tdate[1],$lc_tdate[2]);
}
