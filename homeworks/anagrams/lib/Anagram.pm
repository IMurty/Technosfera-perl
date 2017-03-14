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

use Encode qw(decode encode);
sub anagram {
    my $words_list = shift;
    my %result ;
    foreach my $word (@$words_list) {
		$word = lc(decode('UTF8',$word));
		my $sort_word = str_sort($word);
		if (exists $result{$sort_word}){
			my $words_arr_ref = $result{$sort_word};
			unless (exists_in_arr($words_arr_ref,$word)) {
				push @$words_arr_ref, $word;
				$result{$sort_word} = $words_arr_ref;
			}
		}
		else {
			$result{$sort_word} = [$word];
		}
	}
	return rm_small_arrs(\%result);
};

sub str_sort {
	return join '',sort (split '', shift);
};

sub exists_in_arr {
	my ($words_arr_ref, $word) = @_;
	return scalar grep $word eq $_, @$words_arr_ref;
}

sub rm_small_arrs {
	my $unfiltred_hash_ref = shift;
	my $filtred_hash = {};
	foreach my $key (keys %$unfiltred_hash_ref) {
    	my $words_arr_ref = delete $unfiltred_hash_ref->{$key};
    	unless (@$words_arr_ref < 2){
			@$words_arr_ref = map {encode('UTF8', $_)} @$words_arr_ref;
			my $first_word = $words_arr_ref->[0];
			@$words_arr_ref = sort @$words_arr_ref;
			$filtred_hash->{$first_word} = $words_arr_ref;
		}
	}
	return $filtred_hash;
}
1;
