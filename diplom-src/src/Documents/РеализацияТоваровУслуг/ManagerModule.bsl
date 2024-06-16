#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт

	Если ПравоДоступа("Добавление", Метаданные.Документы.РеализацияТоваровУслуг) Тогда

		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.РеализацияТоваровУслуг.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначения.ПредставлениеОбъекта(
			Метаданные.Документы.РеализацияТоваровУслуг);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";

		Возврат КомандаСоздатьНаОсновании;

	КонецЕсли;

	Возврат Неопределено;

КонецФункции

//ВКМ

Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "АктОказанныхУслуг";
	КомандаПечати.Представление = НСтр("ru = 'Акт оказанных услуг'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Порядок = 5;

КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт

	ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "АктОказанныхУслуг");
	Если ПечатнаяФорма <> Неопределено Тогда
		ПечатнаяФорма.ТабличныйДокумент = АктОказанныхУслуг(МассивОбъектов, ОбъектыПечати);
		ПечатнаяФорма.СинонимМакета = НСтр("ru = 'Акт оказанных услуг'");
		ПечатнаяФорма.ПолныйПутьКМакету = "Документ.РеализацияТоваровУслуг.ВКМ_ПФ_MXL_АктОказанныхУслуг";
	КонецЕсли;

КонецПроцедуры

Функция АктОказанныхУслуг(МассивОбъектов, ОбъектыПечати)

	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_АктОказанныхУслуг";

	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.РеализацияТоваровУслуг.ВКМ_ПФ_MXL_АктОказанныхУслуг");

	ДанныеДокументов = ПолучитьДанныеДокументов(МассивОбъектов);

	ПервыйДокумент = Истина;

	Пока ДанныеДокументов.Следующий() Цикл

		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;

		ПервыйДокумент = Ложь;

		ОбластьЗаголовокДокумента = Макет.ПолучитьОбласть("Заголовок");

		ДанныеПечати = Новый Структура;

		ШаблонЗаголовка = "Акт № %1 от %2";
		ТекстЗаголовка = СтрШаблон(ШаблонЗаголовка, ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(
			ДанныеДокументов.Номер), Формат(ДанныеДокументов.Дата, "ДЛФ=DD"));
		ДанныеПечати.Вставить("ТекстЗаголовка", ТекстЗаголовка);

		ОбластьЗаголовокДокумента.Параметры.Заполнить(ДанныеПечати);

		ТабличныйДокумент.Вывести(ОбластьЗаголовокДокумента);

		ОбластьОрганизация = Макет.ПолучитьОбласть("Организация");
		ОбластьКонтрагент = Макет.ПолучитьОбласть("Контрагент");

		ДанныеПечати = Новый Структура;
		ДанныеПечати.Вставить("ПредставлениеОрганизации", ДанныеДокументов.Организация);
		ДанныеПечати.Вставить("ПредставлениеКонтрагента", ДанныеДокументов.Контрагент);
		ДанныеПечати.Вставить("Основание", ДанныеДокументов.Договор);

		ОбластьОрганизация.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ОбластьОрганизация);

		ОбластьКонтрагент.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ОбластьКонтрагент);

		ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
		ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
		ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);

		ВыборкаУслуги = ДанныеДокументов.Услуги.Выбрать();

		Пока ВыборкаУслуги.Следующий() Цикл

			ОбластьСтрока.Параметры.Заполнить(ВыборкаУслуги);
			ТабличныйДокумент.Вывести(ОбластьСтрока);

		КонецЦикла;

		Отступ = Макет.ПолучитьОбласть("Отступ");
		ТабличныйДокумент.Вывести(Отступ);

		ОбластьИтого = Макет.ПолучитьОбласть("Итого");
		ДанныеПечати = Новый Структура;
		ДанныеПечати.Вставить("СуммаДокумента", ДанныеДокументов.СуммаДокумента);
		ОбластьИтого.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ОбластьИтого);

		ОбластьСуммы = Макет.ПолучитьОбласть("Суммы");
		ДанныеПечати = Новый Структура;
		ДанныеПечати.Вставить("СуммаДокумента", ДанныеДокументов.СуммаДокумента);
		ДанныеПечати.Вставить("СуммаДокументаПропись", ЧислоПрописью(ДанныеДокументов.СуммаДокумента,
			"Л = ru_RU; ДП = Ложь", "рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 2"));

		ОбластьСуммы.Параметры.Заполнить(ДанныеПечати);
		ТабличныйДокумент.Вывести(ОбластьСуммы);

		ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
		ДанныеПечати = Новый Структура;
		ДанныеПечати.Вставить("ПредставлениеОрганизации", ДанныеДокументов.Организация);
		ДанныеПечати.Вставить("ПредставлениеКонтрагента", ДанныеДокументов.Контрагент);
		ОбластьПодвал.Параметры.Заполнить(ДанныеПечати);

		ТабличныйДокумент.Вывести(ОбластьПодвал);

		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
    
    // В табличном документе необходимо задать имя области, в которую был 
    // выведен объект. Нужно для возможности печати комплектов документов.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати,
			ДанныеДокументов.Ссылка);

	КонецЦикла;

	Возврат ТабличныйДокумент;

КонецФункции

Функция ПолучитьДанныеДокументов(МассивОбъектов)

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
				   |  РеализацияТоваровУслуг.Ссылка КАК Ссылка,
				   |  РеализацияТоваровУслуг.ВерсияДанных КАК ВерсияДанных,
				   |  РеализацияТоваровУслуг.ПометкаУдаления КАК ПометкаУдаления,
				   |  РеализацияТоваровУслуг.Номер КАК Номер,
				   |  РеализацияТоваровУслуг.Дата КАК Дата,
				   |  РеализацияТоваровУслуг.Проведен КАК Проведен,
				   |  РеализацияТоваровУслуг.Организация КАК Организация,
				   |  РеализацияТоваровУслуг.Контрагент КАК Контрагент,
				   |  РеализацияТоваровУслуг.Договор КАК Договор,
				   |  РеализацияТоваровУслуг.СуммаДокумента КАК СуммаДокумента,
				   |  РеализацияТоваровУслуг.Основание КАК Основание,
				   |  РеализацияТоваровУслуг.Ответственный КАК Ответственный,
				   |  РеализацияТоваровУслуг.Комментарий КАК Комментарий,
				   |  РеализацияТоваровУслуг.Товары.(
				   |    Ссылка КАК Ссылка,
				   |    НомерСтроки КАК НомерСтроки,
				   |    Номенклатура КАК Номенклатура,
				   |    Количество КАК Количество,
				   |    Цена КАК Цена,
				   |    Сумма КАК Сумма
				   |  ) КАК Товары,
				   |  РеализацияТоваровУслуг.Услуги.(
				   |    Ссылка КАК Ссылка,
				   |    НомерСтроки КАК НомерСтроки,
				   |    Номенклатура КАК Номенклатура,
				   |    Количество КАК Количество,
				   |    Цена КАК Цена,
				   |    Сумма КАК Сумма
				   |  ) КАК Услуги,
				   |  РеализацияТоваровУслуг.Представление КАК Представление,
				   |  РеализацияТоваровУслуг.МоментВремени КАК МоментВремени
				   |ИЗ
				   |  Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
				   |ГДЕ
				   |  РеализацияТоваровУслуг.Ссылка В(&МассивОбъектов)";

	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);

	Возврат Запрос.Выполнить().Выбрать();

КонецФункции

//ВКМ

#КонецОбласти

#КонецЕсли