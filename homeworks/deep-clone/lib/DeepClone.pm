package DeepClone;

use 5.010;
use strict;
use warnings;

=encoding UTF8

=head1 SYNOPSIS

Клонирование сложных структур данных

=head1 clone($orig)

Функция принимает на вход ссылку на какую либо структуру данных и отдаюет, в качестве результата, ее точную независимую копию.
Это значит, что ни один элемент результирующей структуры, не может ссылаться на элементы исходной, но при этом она должна в точности повторять ее схему.

Входные данные:
* undef
* строка
* число
* ссылка на массив
* ссылка на хеш
Элементами ссылок на массив и хеш, могут быть любые из указанных выше конструкций.
Любые отличные от указанных типы данных -- недопустимы. В этом случае результатом клонирования должен быть undef.

Выходные данные:
* undef
* строка
* число
* ссылка на массив
* ссылка на хеш
Элементами ссылок на массив или хеш, не могут быть ссылки на массивы и хеши исходной структуры данных.

=cut

sub pre_clone {
	my $orign = shift;
   my $map = shift;
	my $clone;
   if (!defined $orign) {
   	return undef;
   }
	elsif (exists $map->{$orign}) {
    	return $map->{$orign};
   }
	if (my $ref = ref $orign){
	   if ($ref eq 'ARRAY') {
	   	$map->{$orign} = $clone = [];
	   	push @$clone, pre_clone($_, $map) for @$orign;
			return $clone;
	   }
	   elsif ($ref eq 'HASH') {
			$map->{$orign} = $clone = {};
	   	$clone->{$_} = pre_clone($orign->{$_}, $map) for keys %$orign;
			return $clone;
	   }
	   else {
	   	die 'Undef';
	   }
	}
	else {
		return $orign;
	}
};

sub clone {
	my $orign = shift;
	my $clone;
	eval {
		my $map = {};
		$clone = pre_clone($orign, $map);
	}
	|| do {
		$clone = undef;
	};
	return $clone;
}
1;
