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
    my %result;
    foreach my $word (@$words_list) {
		$word = lc(decode('UTF8',$word));
		$word = encode('UTF8', $word);
		my $sort_word = str_sort($word);
		if (exists $result{$sort_word}){
			my $arr_ref = $result{$sort_word};
			unless (exists_in_arr($arr_ref,$word)) {
				push @$arr_ref, $word;
				$result{$sort_word} = $arr_ref;
			}
		}
		else {
			$result{$sort_word} = [$word];
		}
	}
	return rm_small_arrs(\%result);
};

sub return_key {
	my ($hash_ref, $add_word) = @_;
	foreach my $key (keys %$hash_ref) {
    	if (str_sort($key) eq str_sort($add_word)) {
			return $key;
    	}
	}
	return undef;
};

sub str_sort {
	return join '',sort (split '', shift);
};

sub exists_in_arr {
	my ($arr_ref, $word) = @_;
	return scalar grep $word eq $_, @$arr_ref;
}

sub rm_small_arrs {
	my $hash_ref = shift;
	my %hash;
	foreach my $key (keys %$hash_ref) {
    	my $arr_ref = $hash_ref->{$key};
    	if (@$arr_ref < 2){
        	delete $hash_ref->{$key};
    	}
		else {
			my $first = $arr_ref->[0];
			@$arr_ref = sort @$arr_ref;
			$hash{$first} = $arr_ref;
			delete $hash_ref->{$key};
		}
	}
	return \%hash;
}
1;
