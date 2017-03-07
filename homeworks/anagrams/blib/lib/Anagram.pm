package Anagram;

use 5.010;
use strict;
use warnings;

=encoding UTF8

=head1 SYNOPSIS

Поиск анаграмм

=head1 anagram($arrayref)

Функцию поиска всех множеств анаграмм по словарю.

Входные данные для функции: ссылка на массив - каждый элемент которого - слово на русском языке в кодировке utf8

Выходные данные: Ссылка на хеш множеств анаграмм.

Ключ - первое встретившееся в словаре слово из множества
Значение - ссылка на массив, каждый элемент которого слово из множества, в том порядке в котором оно встретилось в словаре в первый раз.

Множества из одного элемента не должны попасть в результат.

Все слова должны быть приведены к нижнему регистру.
В результирующем множестве каждое слово должно встречаться только один раз.
Например

anagram(['пятак', 'ЛиСток', 'пятка', 'стул', 'ПяТаК', 'слиток', 'тяпка', 'столик', 'слиток'])

должен вернуть ссылку на хеш


{
    'пятак'  => ['пятак', 'пятка', 'тяпка'],
    'листок' => ['листок', 'слиток', 'столик'],
}

=cut

sub anagram {
    my $words_list = shift;
    my @words = @$words_list;
    my %result;
    foreach my $word (@words) {
      $word = lc($word);
      my $have_key = return_key (\%result, $word);
      if ($have_key) {
         my $arr_href = $result{$have_key};
         unless (exists_in($arr_href,$word)) {
            my @push_arr = @$arr_href;
            push @push_arr, $word;
            $result{$have_key} = \@push_arr;
         }
      }
      else {
         my @push_arr = ();
         push @push_arr, $word;
         $result{$word} = \@push_arr;
      }
   }
   return rm_small_arrs(\%result);
};

sub return_key {
   my ($href, $add_word) = @_;
   my %hash = %$href;
   foreach my $key (keys %hash) {
      if (str_sort($key) eq str_sort($add_word)) {
         return $key;
      }
   }
   return undef;
};

sub str_sort {
   my $word = shift;
   my @word = split '', $word;
   my $str = join '',sort @word;
   return lc($str);
};

sub exists_in {
   my ($arr_href, $word) = @_;
   foreach my $word_in_arr (@$arr_href) {
      if (lc($word_in_arr) eq lc($word)){
         return 1;
      }
   }
   return undef;
};

sub rm_small_arrs {
   my $href = shift;
   my %hash = %$href;
   foreach my $key (keys %hash) {
      my $arr_href = $hash{$key};
      my @arr = @$arr_href;
      if ((scalar @arr) < 2){
         delete $hash{$key};
      }
   }
   return \%hash;
}
1;
