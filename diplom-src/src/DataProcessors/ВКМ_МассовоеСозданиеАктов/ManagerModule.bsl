Функция ЗаполнитьНаСервере(ДатаНачала, ДатаОкончания) Экспорт
  
  Запрос = Новый Запрос;
  Запрос.Текст = "ВЫБРАТЬ
                 |  РеализацияТоваровУслуг.Ссылка КАК Ссылка
                 |ПОМЕСТИТЬ ВТ_Реализации
                 |ИЗ
                 |  Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
                 |ГДЕ
                 |  РеализацияТоваровУслуг.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
                 |  И НЕ РеализацияТоваровУслуг.ПометкаУдаления
                 |;
                 |
                 |////////////////////////////////////////////////////////////////////////////////
                 |ВЫБРАТЬ
                 |  ДоговорыКонтрагентов.Ссылка КАК Договор,
                 |  ВТ_Реализации.Ссылка КАК Реализация
                 |ИЗ
                 |  ВТ_Реализации КАК ВТ_Реализации
                 |    ПРАВОЕ СОЕДИНЕНИЕ Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
                 |    ПО (ДоговорыКонтрагентов.Ссылка = ВТ_Реализации.Ссылка.Договор)
                 |ГДЕ
                 |  ДоговорыКонтрагентов.ВидДоговора = &ВидДоговора";
  
  Запрос.УстановитьПараметр("ВидДоговора", Перечисления.ВидыДоговоровКонтрагентов.ВКМ_АбоненскоеОбслуживание);
  Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
  Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
  
  Выборка = Запрос.Выполнить().Выбрать();
  
  СписокРеализацийМассив = Новый Массив;
  
  Пока Выборка.Следующий() Цикл
    
    СписокРеализацийСтруктура = Новый Структура;
    
    Если НЕ ЗначениеЗаполнено(Выборка.Реализация) Тогда
      НоваяРеализация = СоздатьНовыйРеализация(Выборка.Договор, ДатаОкончания);
      СписокРеализацийСтруктура.Вставить("Договор", Выборка.Договор);
      СписокРеализацийСтруктура.Вставить("Реализация", НоваяРеализация);
      
    Иначе
      СписокРеализацийСтруктура.Вставить("Договор", Выборка.Договор);
      СписокРеализацийСтруктура.Вставить("Реализация", Выборка.Реализация);
      
    КонецЕсли;
    
    СписокРеализацийМассив.Добавить(СписокРеализацийСтруктура);
    
  КонецЦикла;
  
  Возврат СписокРеализацийМассив;
  
КонецФункции

Функция СоздатьНовыйРеализация(Договор, ДатаСозданияНовойРеализации)
  
  НоваяРеализация = Документы.РеализацияТоваровУслуг.СоздатьДокумент();
  НоваяРеализация.ВКМ_ВыполнитьАвтозаполнение(Договор, ДатаСозданияНовойРеализации);
  НоваяРеализация.Дата = ДатаСозданияНовойРеализации;
  //НоваяРеализация.Ответственный = Пользователи.ТекущийПользователь();
  НоваяРеализация.Договор = Договор;
  НоваяРеализация.Контрагент = Договор.Владелец;
  НоваяРеализация.Организация = Договор.Организация;
  НоваяРеализация.Комментарий = "Создано обработкой";
  НоваяРеализация.Записать(РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Неоперативный);
  
  Возврат НоваяРеализация.Ссылка;
  
КонецФункции