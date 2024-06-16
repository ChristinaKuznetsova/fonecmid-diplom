#Область ПрограммныйИнтерфейс

Процедура ДополнитьФорму(Форма) Экспорт
  
  ИмяФормы = Форма.ИмяФормы;
  
  Если ИмяФормы = "Справочник.ДоговорыКонтрагентов.Форма.ФормаЭлемента" Тогда
    ДобавитьДанныеАбонентскоеОбслуживание(Форма);
  ИначеЕсли ИмяФормы = "Документ.РеализацияТоваровУслуг.Форма.ФормаДокумента" Тогда
  	ДобавитьКнопкаЗаполнить(Форма);
  
    //ДобавитьПолеСогласованнаяСкидкаВГруппаОбычная(Форма);
    //ДобавитьКнопкаПересчитатьТаблицуВГруппаОбычная(Форма);
  //ИначеЕсли ИмяФормы = "Документ.ПоступлениеТоваровУслуг.Форма.ФормаДокумента" Тогда
    //ДобавитьПолеКонтактноеЛицоВГруппаШапкаПраво(Форма);
  //ИначеЕсли ИмяФормы = "Документ.ОплатаОтПокупателя.Форма.ФормаДокумента" Тогда
    //ВставитьПолеКонтактноеЛицоНаФормуПередСуммаДокумента(Форма);
  //ИначеЕсли ИмяФормы = "Документ.ОплатаПоставщику.Форма.ФормаДокумента" Тогда
    //ВставитьПолеКонтактноеЛицоНаФормуПередСуммаДокумента(Форма);
  КонецЕсли;
  
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ДобавитьДанныеАбонентскоеОбслуживание(Форма) Экспорт

	ГруппаШапка = Форма.Элементы.Добавить("ГруппаШапка", Тип("ГруппаФормы"), Форма);
	ГруппаШапка.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаШапка.Отображение = ОтображениеОбычнойГруппы.Нет;
	ГруппаШапка.Заголовок = "Дополнительные данные";
	ГруппаШапка.ОтображатьЗаголовок = Истина;
	ГруппаШапка.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	//Форма.Элементы.ГруппаШапка.Видимость = Ложь;

	ГруппаДоговор = Форма.Элементы.Добавить("ГруппаДоговор", Тип("ГруппаФормы"), Форма.Элементы.ГруппаШапка);
	ГруппаДоговор.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаДоговор.Отображение = ОтображениеОбычнойГруппы.Нет;
	ГруппаДоговор.ОтображатьЗаголовок = Ложь;
	ГруппаДоговор.Группировка = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда;

	ГруппаСумма = Форма.Элементы.Добавить("ГруппаСумма", Тип("ГруппаФормы"), ГруппаШапка);
	ГруппаСумма.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаСумма.Отображение = ОтображениеОбычнойГруппы.Нет;
	ГруппаСумма.ОтображатьЗаголовок = Ложь;
	ГруппаСумма.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;

	ПолеВвода = Форма.Элементы.Добавить("ДатаНачала", Тип("ПолеФормы"), ГруппаДоговор);
	ПолеВвода.Заголовок = "Дата начала";
	ПолеВвода.Вид = ВидПоляФормы.ПолеВвода;
	ПолеВвода.ПутьКДанным = "Объект.ВМК_ДатаНачала";

	ПолеВвода = Форма.Элементы.Добавить("ДатаОкончания", Тип("ПолеФормы"), ГруппаДоговор);
	ПолеВвода.Заголовок = "Дата окончания";
	ПолеВвода.Вид = ВидПоляФормы.ПолеВвода;
	ПолеВвода.ПутьКДанным = "Объект.ВМК_ДатаОкончания";

	ПолеВвода = Форма.Элементы.Добавить("СуммаАбоненскойПлаты", Тип("ПолеФормы"), ГруппаСумма);
	ПолеВвода.Заголовок = "Сумма абоненской платы";
	ПолеВвода.Вид = ВидПоляФормы.ПолеВвода;
	ПолеВвода.ПутьКДанным = "Объект.ВМК_СуммаАбоненскойПлаты";

	ПолеВвода = Форма.Элементы.Добавить("СтоимостьЧасаРаботы", Тип("ПолеФормы"), ГруппаСумма);
	ПолеВвода.Заголовок = "Стоимость часа работы";
	ПолеВвода.Вид = ВидПоляФормы.ПолеВвода;
	ПолеВвода.ПутьКДанным = "Объект.ВМК_СтоимостьЧасаРаботы";
	
КонецПроцедуры

Процедура ДобавитьКнопкаЗаполнить (Форма) Экспорт

Команда = Форма.Команды.Добавить ("Заполнить");
Команда.Заголовок = "Заполнить";
Команда.Действие = "ВКМ_Заполнить";

КнопкаФормы = Форма.Элементы.Добавить("КнопкаЗаполнить", Тип ("КнопкаФормы"), Форма.КоманднаяПанель);
КнопкаФормы.ИмяКоманды = "Заполнить";
КнопкаФормы.Вид = ВидКнопкиФормы.ОбычнаяКнопка;
КнопкаФормы.Отображение = ОтображениеКнопки.КартинкаИТекст;
КнопкаФормы.Картинка = БиблиотекаКартинок.ЗаполнитьФорму;

КонецПроцедуры

#КонецОбласти
