import 'dart:html';

void main() {
  querySelector("#btnCalc").onClick.listen(calculateDose);
  querySelector("#pump_scale").onChange.listen(clearDose);
}

TextInputElement getTextInput(String id){
  return querySelector(id);
}

void clearDose(Event event){
  getTextInput("#potion_dose").value = "";
}

void calculateDose(MouseEvent event) {
  var warter_input = ParseNumber("#warter_input");
  var potion_ppm = ParseNumber("#potion_ppm");
  var potion_volumn = ParseNumber("#potion_volumn");
  var pump_max_flow = ParseNumber("#pump_max_flow");

  var potion_input = warter_input * potion_ppm;
  getTextInput("#potion_input").value = potion_input.toString();

  setErrorMsg("#potion_dose", "");

  if(getTextInput("#potion_dose").value != ""){
    var potion_dose = ParseNumber("#potion_dose");

    if(potion_volumn != 0.0){
      var potion_concentration = potion_dose * 1000 / potion_volumn;
      getTextInput("#potion_concentration").value = potion_concentration.toString();

      var pump_flow = potion_input / potion_concentration;
      getTextInput("#pump_flow").value = pump_flow.toString();

      if(pump_max_flow != 0.0){
        var pump_scale = pump_flow * 100 / pump_max_flow;
        getTextInput("#pump_scale").value = pump_scale.toStringAsFixed(2);

        if(pump_scale > 100){
          setErrorMsg("#potion_dose", "用量太少，不能满足要求");
        }
      }
    }
    return;
  }

  if(getTextInput("#pump_scale").value != ""){
    var pump_scale = ParseNumber("#pump_scale");
    var pump_flow = pump_scale / 100 * pump_max_flow;
    getTextInput("#pump_flow").value = pump_flow.toString();

    if(pump_flow != 0.0){
      var potion_concentration = potion_input / pump_flow;
      getTextInput("#potion_concentration").value = potion_concentration.toString();

      var potion_dose = potion_concentration * potion_volumn / 1000;
      if(potion_dose != 0.0){
        getTextInput("#potion_dose").value = potion_dose.toString();
      }
    }
    return;
  }

  setErrorMsg("#potion_dose", "需要填入数字");
}

double ParseNumber(String elementID){
  TextInputElement elem = getTextInput(elementID);
  elem.nextElementSibling.text = "";
  return double.parse(elem.value, onErrorFunc(elem));
}

void setErrorMsg(String elementID, String msg){
  Element elem = querySelector(elementID);
  elem.nextElementSibling.text = msg;
}

Function onErrorFunc(Element textInput){
  return (String str){
    var msg;
    if(str == ""){
      msg = "需要填入数字";
    }else{
      msg = "数字格式错误";
    }
    textInput.nextElementSibling.text = msg;
    return 0.0;
  };
}