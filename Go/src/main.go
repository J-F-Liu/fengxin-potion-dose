package main

import (
	"fmt"
	"github.com/lxn/walk"
	. "github.com/lxn/walk/declarative"
	"os/exec"
	"strconv"
)

var warter_inputTE, potion_ppmTE, potion_inputTE *walk.LineEdit
var potion_doseTE, potion_volumnTE, potion_concentrationTE *walk.LineEdit
var pump_flowTE, pump_max_flowTE, pump_scaleTE *walk.LineEdit
var potion_doseLB, companyLB *walk.Label
var mw *walk.MainWindow

func main() {
	defer func() {
		if e := recover(); e != nil {
			walk.MsgBox(mw, "Error", fmt.Sprintf("%v", e), walk.MsgBoxIconInformation)
		}
	}()

	MainWindow{
		AssignTo: &mw,
		Title:    "阻垢剂加药量计算器",
		MinSize:  Size{600, 450},
		Layout:   VBox{},
		Children: []Widget{
			Composite{
				Layout: HBox{},
				Children: []Widget{
					Label{Text: "用*标注的为必填项，用#标注的二者选填其一。"},
					HSpacer{},
				},
			},
			Composite{
				Layout: Grid{Columns: 3},
				Children: []Widget{
					Label{Text: "*设备进水流量（T/h）："},
					LineEdit{AssignTo: &warter_inputTE},
					Label{Text: ""},

					Label{Text: "*推荐加药剂量（g/T）："},
					LineEdit{AssignTo: &potion_ppmTE},
					Label{Text: ""},

					Label{Text: "药剂注入量（g/h）："},
					LineEdit{AssignTo: &potion_inputTE, ReadOnly: true},
					Label{Text: ""},

					Label{Text: "#药剂标准液用量（kg）："},
					LineEdit{AssignTo: &potion_doseTE},
					Label{Text: "", AssignTo: &potion_doseLB},

					Label{Text: "*所需配制的药液体积（L）："},
					LineEdit{AssignTo: &potion_volumnTE},
					Label{Text: ""},

					Label{Text: "药液浓度（g/L）："},
					LineEdit{AssignTo: &potion_concentrationTE, ReadOnly: true},
					Label{Text: ""},

					Label{Text: "计量泵实际流量（L/h）："},
					LineEdit{AssignTo: &pump_flowTE, ReadOnly: true},
					Label{Text: ""},

					Label{Text: "*计量泵最大流量（L/h）："},
					LineEdit{AssignTo: &pump_max_flowTE},
					Label{Text: ""},

					Label{Text: "#计量泵刻度（%）："},
					LineEdit{AssignTo: &pump_scaleTE},
					Label{Text: ""},
				},
			},

			Composite{
				Layout: HBox{},
				Children: []Widget{
					HSpacer{},
					PushButton{
						Text:      "计算",
						MaxSize:   Size{120, 23},
						OnClicked: calculateDose,
					},
					HSpacer{},
				},
			},
			Composite{
				Layout: HBox{},
				Children: []Widget{
					Label{Text: "上海丰信环保科技有限公司 http://www.pnt-ro.com/",
						AssignTo: &companyLB,
						//OnClicked: openWebsite
					},
					HSpacer{},
				},
			},
		},
	}.Create()

	if ic, err := walk.NewIconFromFile("icon.ico"); err == nil {
		mw.SetIcon(ic)
	} else {
		//walk.MsgBox(mw, "Error", err.Error(), walk.MsgBoxIconInformation)
	}

	//font := companyLB.Font()
	//newFont, _ := walk.NewFont(font.Family(), font.PointSize(), walk.FontUnderline)
	//companyLB.SetFont(newFont)

	mw.Run()
}

func calculateDose() {
	warter_input := ParseNumber(warter_inputTE)
	potion_ppm := ParseNumber(potion_ppmTE)

	potion_input := warter_input * potion_ppm
	potion_inputTE.SetText(fmt.Sprint(potion_input))

	potion_volumn := ParseNumber(potion_volumnTE)
	pump_max_flow := ParseNumber(pump_max_flowTE)

	potion_doseLB.SetText("")

	if potion_doseTE.Text() != "" {
		potion_dose := ParseNumber(potion_doseTE)

		if potion_volumn != 0.0 {
			potion_concentration := potion_dose * 1000 / potion_volumn
			potion_concentrationTE.SetText(fmt.Sprint(potion_concentration))

			pump_flow := potion_input / potion_concentration
			pump_flowTE.SetText(fmt.Sprint(pump_flow))

			if pump_max_flow != 0.0 {
				pump_scale := pump_flow * 100 / pump_max_flow
				pump_scaleTE.SetText(fmt.Sprint(pump_scale))

				if pump_scale > 100 {
					potion_doseLB.SetText("用量太少，不能满足要求")
				}
			}
		}
		return
	}

	if pump_scaleTE.Text() != "" {
		pump_scale := ParseNumber(pump_scaleTE)
		pump_flow := pump_scale / 100 * pump_max_flow
		pump_flowTE.SetText(fmt.Sprint(pump_flow))

		if pump_flow != 0.0 {
			potion_concentration := potion_input / pump_flow
			potion_concentrationTE.SetText(fmt.Sprint(potion_concentration))

			potion_dose := potion_concentration * potion_volumn / 1000
			if potion_dose != 0.0 {
				potion_doseTE.SetText(fmt.Sprint(potion_dose))
			}
		}
		return
	}

	potion_doseLB.SetText("需要填入数字")
}

func ParseNumber(textbox *walk.LineEdit) float64 {
	number, err := strconv.ParseFloat(textbox.Text(), 64)
	widgets := textbox.Parent().Children()
	index := widgets.Index(textbox)
	label := widgets.At(index + 1).(*walk.Label)
	if err != nil {
		label.SetText("需要填入数字")
	} else {
		label.SetText("")
	}
	return number
}

func openWebsite() {
	cmd := exec.Command("http://www.pnt-ro.com/")
	cmd.Start()
}
