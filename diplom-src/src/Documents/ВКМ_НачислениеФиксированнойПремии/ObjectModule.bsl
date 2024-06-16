#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	СформироватьДвижения();

	РассчитатьНДФЛ();

	РассчитатьЗарплатуКВыплате();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СформироватьДвижения()

	Для Каждого ТекСтрокаСписокСотрудников Из СписокСотрудников Цикл  
    // Движения по регистру ВКМ_ДополнительныеНачисления
		Движение = Движения.ВКМ_ДополнительныеНачисления.Добавить();
		Движение.ПериодРегистрации = Дата;
		Движение.ВидРасчета = ТекСтрокаСписокСотрудников.ВидРасчета;
		Движение.Сотрудник = ТекСтрокаСписокСотрудников.Сотрудник;
		Движение.Результат = ТекСтрокаСписокСотрудников.СуммаНачисления;
	КонецЦикла;

	Движения.ВКМ_ДополнительныеНачисления.Записать();

КонецПроцедуры

Процедура РассчитатьНДФЛ()

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
				   |  ВКМ_ДополнительныеНачисления.Сотрудник КАК Сотрудник,
				   |  СУММА(ВКМ_ДополнительныеНачисления.Результат) КАК Результат
				   |ИЗ
				   |  РегистрРасчета.ВКМ_ДополнительныеНачисления КАК ВКМ_ДополнительныеНачисления
				   |ГДЕ
				   |  ВКМ_ДополнительныеНачисления.Регистратор.Ссылка = &Ссылка
				   |
				   |СГРУППИРОВАТЬ ПО
				   |  ВКМ_ДополнительныеНачисления.Сотрудник";

	Запрос.УстановитьПараметр("Ссылка", Ссылка);

	Выборка = Запрос.Выполнить().Выбрать();
  
  // Движения по регистру ВКМ_Удержания 
	Пока Выборка.Следующий() Цикл
		Движение = Движения.ВКМ_Удержания.Добавить();
		Движение.ПериодРегистрации = Дата;
		Движение.Сотрудник = Выборка.Сотрудник;
		Движение.ВидРасчета = ПланыВидовРасчета.ВКМ_Удержания.НДФЛ;
		Движение.НДФЛ = (Выборка.Результат * 13) / 100;
	КонецЦикла;

	Движения.ВКМ_Удержания.Записать();

КонецПроцедуры

Процедура РассчитатьЗарплатуКВыплате()

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
				   |  ВКМ_ДополнительныеНачисления.Сотрудник КАК Сотрудник,
				   |  СУММА(ВКМ_ДополнительныеНачисления.Результат) КАК Результат,
				   |  ВКМ_Удержания.НДФЛ КАК НДФЛ
				   |ИЗ
				   |  РегистрРасчета.ВКМ_ДополнительныеНачисления КАК ВКМ_ДополнительныеНачисления
				   |    ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрРасчета.ВКМ_Удержания КАК ВКМ_Удержания
				   |    ПО ВКМ_ДополнительныеНачисления.Сотрудник = ВКМ_Удержания.Сотрудник
				   |ГДЕ
				   |  ВКМ_ДополнительныеНачисления.Регистратор.Ссылка = &Ссылка
				   |  И ВКМ_Удержания.Регистратор = &Ссылка
				   |СГРУППИРОВАТЬ ПО
				   |  ВКМ_ДополнительныеНачисления.Сотрудник,
				   |  ВКМ_Удержания.НДФЛ";

	Запрос.УстановитьПараметр("Ссылка", Ссылка);

	Выборка = Запрос.Выполнить().Выбрать();

	Пока Выборка.Следующий() Цикл
		Движение = Движения.ВКМ_ВзаиморасчетыССотрудниками.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.Сотрудник = Выборка.Сотрудник;
		Движение.Сумма = Выборка.Результат - Выборка.НДФЛ;
	КонецЦикла;

	Движения.ВКМ_ВзаиморасчетыССотрудниками.Записать();

КонецПроцедуры

#КонецОбласти

#КонецЕсли