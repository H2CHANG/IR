#!/usr/bin/perl

use strict;
use warnings;

# use module
use XML::Simple;
use Data::Dumper;
use Lingua::EN::PluralToSingular 'to_singular';
use Lingua::EN::Sentence qw( get_sentences add_acronyms );

our @pubmed_data;
our %word_data;
our %true_data;
# create object
my $xml = new XML::Simple (KeyAttr=>[]);

my $data = $xml->XMLin("test1.txt");
my ($key1, $value1, @key_array);
my $xml_file;
my $out_file;
open $xml_file, '>', 'data2.txt'
    or die "can't open $!";

open $out_file, '>', 'data4.txt'
    or die "can't open $!";

#dereference hash ref
#
print "test",$data->{MedlineCitation}->{Article}->{Abstract}->{AbstractText}, "\n";

traverse( $data );
print "\n------------------------------------------------\n";
 
#print to_singular ('S');
#print "\n------------------------------------------------\n";
add_acronyms('lt','gen');               ## adding support for 'Lt. Gen.'
foreach (@pubmed_data){
    my $sentences=get_sentences($_);     ## Get the sentences.
    foreach my $sentence (@$sentences) {
        print $xml_file "$sentence\n";
        }
    
    }
close $xml_file;

=begin comment
foreach (sort keys %pubmed_data ){
    
    print "key = $_\n";
    print "value = $pubmed_data{$_}\n";
    $key1 = $_;
    $key1=~ s/!\s+//;
    $value1 = $pubmed_data{$_};
    @key_array = split(/\s+/, $key1);
    foreach (@key_array) {
        if (exists $word_data{$_} ) {
            $word_data{$_}++;
            
            }
        else {
            $word_data{$_} = $value1;
            }
        
        }
    
    }

foreach (sort keys %word_data ){
    my $key = $_;
    my $value = $word_data{$_};
    my $sigular_key;
    #$_ =~ s/(.*),/$1/;
    #$key =~ s/(.*),/$1/;
    #$key =~ s/\((.*)\)/$1/;
    #$key =~ s/(.*)(\.|\?|\:)$/$1/;
    $key =~ s/[^\w\d\s]//g;
    $key = lc $key;
    
    $sigular_key = to_singular ($key);
    $sigular_key = $key if ($key eq 's');
    if (exists $true_data{$sigular_key}{1} ) {
            $true_data{$sigular_key}{1} += $value;
            
            }
    else {
             $true_data{$sigular_key}{1} = $value;
            }
    print $xml_file "key = $key\n";
    print $xml_file "value = $value\n";
    
    
   }

close $xml_file;
foreach (sort keys %true_data) {
    print $out_file "key = $_\n";
    print $out_file "value =  $true_data{$_}{1}\n";
       
    }
close $out_file;

=end comment
=cut

sub traverse {
    our @pubmed_data;
    my ($element) = @_;
    if( ref( $element ) =~ /HASH/ ) {
        foreach my $key (keys %$element) {
  #          print "key=$key\n";
  #          next if ($key eq "PubmedData");
            traverse( $$element{$key} );
            }
    } 
    elsif( ref( $element)  =~ /ARRAY/ )  {
        #my $i = $_[0];
        traverse( $_ ) foreach @$element;
    } 
    else {
   #     print "$element\n";
       push @pubmed_data, $element;
    }
}