#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	РаскраситьСтроку();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьСотрудников(Команда)
	ЗаполнитьСотрудниковНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСотрудниковНаСервере()

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
				   |  ВКМ_Сотрудники.Ссылка КАК Сотрудник
				   |ИЗ
				   |  Справочник.ВКМ_Сотрудники КАК ВКМ_Сотрудники";

	Выборка = Запрос.Выполнить().Выбрать();

	Объект.ОтпускаСотрудников.Очистить();

	Пока Выборка.Следующий() Цикл

		НоваяСтрока = Объект.ОтпускаСотрудников.Добавить();
		НоваяСтрока.Сотрудник = Выборка.Сотрудник;

	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьАнализГрафика(Команда)

	Адрес = ЗаписьДанныхДляДопформы();
	ПараметрыФормы = Новый Структура("Адрес", Адрес);

	ОткрытьФорму("Документ.ВКМ_ГрафикОтпусков.Форма.График", ПараметрыФормы, Элементы.ОтпускаСотрудников);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ЗаписьДанныхДляДопформы()

	Возврат ПоместитьВоВременноеХранилище(Объект.ОтпускаСотрудников.Выгрузить( ,
		"Сотрудник, ДатаНачала, ДатаОкончания"));

КонецФункции

&НаКлиенте
Процедура ОтпускаСотрудниковДатаОкончанияПриИзменении(Элемент)

	ТекущиеДанные = Элементы.ОтпускаСотрудников.ТекущиеДанные;

	Если ЗначениеЗаполнено(ТекущиеДанные.ДатаНачала) И ТекущиеДанные.ДатаНачала > ТекущиеДанные.ДатаОкончания Тогда

		ОбщегоНазначенияКлиент.СообщитьПользователю("Дата окончания не может быть меньше даты начала");

	Иначе
		ТекущиеДанные.ВсегоДнейОтпуска = (НачалоДня(ТекущиеДанные.ДатаОкончания) - НачалоДня(ТекущиеДанные.ДатаНачала))
			/ (60 * 60 * 24);

		РаскраситьСтроку();

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОтпускаСотрудниковДатаНачалаПриИзменении(Элемент)

	ТекущиеДанные = Элементы.ОтпускаСотрудников.ТекущиеДанные;

	Если ЗначениеЗаполнено(ТекущиеДанные.ДатаОкончания) И ТекущиеДанные.ДатаНачала > ТекущиеДанные.ДатаОкончания Тогда

		ОбщегоНазначенияКлиент.СообщитьПользователю("Дата начала не может быть больше даты окончания");

	Иначе
		ТекущиеДанные.ВсегоДнейОтпуска = (КонецДня(ТекущиеДанные.ДатаОкончания) - НачалоДня(ТекущиеДанные.ДатаНачала)
			- 86400) / (60 * 60 * 24);

		РаскраситьСтроку();

	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура РаскраситьСтроку()

	ТЗ =  Объект.ОтпускаСотрудников.Выгрузить( , "Сотрудник, ВсегоДнейОтпуска");
	ТЗ.Свернуть("Сотрудник", "ВсегоДнейОтпуска");
	УсловноеОформление.Элементы.Очистить();

	Для Каждого Колонка Из ТЗ Цикл

		Если Колонка.ВсегоДнейОтпуска > 28 Тогда

			Оформление  = УсловноеОформление.Элементы.Добавить();
			Оформление.Использование = Истина;

			ПолеОформляемое = Оформление.Поля.Элементы.Добавить();
			ПолеОформляемое.Поле = Новый ПолеКомпоновкиДанных("ОтпускаСотрудников");

			Отбор = Оформление.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ОтпускаСотрудников.Сотрудник");
			Отбор.ПравоеЗначение = Колонка.Сотрудник;
			Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			Отбор.Использование = Истина;
			Оформление.Оформление.УстановитьЗначениеПараметра("ЦветФона", WebЦвета.Розовый);

			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрШаблон(
				"ВНИМАНИЕ! Общая длительность всех отпусков превышает 28 дней у сотрудника %1. И составляет %2 дней",
				Колонка.Сотрудник, Колонка.ВсегоДнейОтпуска));

		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ОтпускаСотрудниковВсегоДнейОтпускаПриИзменении(Элемент)

	РаскраситьСтроку();

КонецПроцедуры
#КонецОбласти