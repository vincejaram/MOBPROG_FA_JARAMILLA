import 'package:fa4_reverse_engineering/models/supply.dart';
import 'package:flutter/material.dart';

class SupplyItem extends StatelessWidget {
  final Supply supply;

  const SupplyItem(this.supply, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: (MediaQuery.sizeOf(context).height)*0.12,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(supply.name,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 20)),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('\$${supply.price} X ${supply.quantity} = \$${(supply.price*supply.quantity).toDouble()}',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14)),
                  Spacer(),
                  Container(
                    height: 20,
                    width: 20,
                    color: supply.parameter.color,
                  ),
                  SizedBox(width: 5),
                  Text(supply.parameter.parameterName,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
