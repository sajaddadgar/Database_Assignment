-- Section1
create trigger t1
after insert on order_details
for each row
  begin

    update products
    set products.quantity_in_stock = products.quantity_in_stock - NEW.quantity_ordered
    where products.id = new.product_id;
  end;
$$
create trigger t2
  after update on order_details
  for each row
  begin

      update products
      set products.quantity_in_stock = products.quantity_in_stock - new.quantity_ordered + OLD.quantity_ordered
      where products.id = NEW.product_id;
  end;
$$
create trigger t3
  after delete on order_details
  for each row
  begin

    update products
      set products.quantity_in_stock = products.quantity_in_stock + OLD.quantity_ordered
    where products.id = OLD.product_id;

  end;
-- Section2
create view view1
  as select products.id, products.name, sum(quantity_ordered), sum(quantity_ordered * (price_each - buy_price))
    from products inner join order_details on products.id = order_details.product_id group by products.id;
-- Section3
create procedure proc1(in x date, out total int)
begin

  select COUNT(*) into total from orders inner join payments
    on payments.order_id = orders.id where orders.order_date < x and payments.id is null;

  delete from order_details where order_id in (select id from orders where orders.order_date < x and id not in (
    select payments.order_id from payments));

    delete from orders where orders.order_date < x and id not in (
    select payments.order_id from payments);

end;

-- Section4
create trigger t4
  after insert on payments
  for each row
  begin

    if (NEW.payment_type = 'cash') then

      update orders set orders.shipped_date = NEW.payment_date where orders.id = NEW.order_id and orders.shipped_date is null;

    end if;

  end ;

-- Section5
create procedure proc2(in x int)
begin
  select products.id, products.name
  from products
  where products.id in
        (
            select order_details.product_id from order_details group by order_details.product_id having sum(quantity_ordered) > x
        );
end;