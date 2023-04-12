PIC_AS=/opt/microchip/xc8/v2.36/pic-as/bin/pic-as
PIC_CLANG=/opt/microchip/xc8/v2.36/pic/bin/clang

CHIP=16F88
DFP=/opt/microchip/mplabx/v6.05/packs/Microchip/PIC16Fxxx_DFP/1.3.42/xc8

BUILD_DIR=build

main.hex: main.s
	rm -rf ${BUILD_DIR}
	mkdir ${BUILD_DIR}
	cat main.s | ${PIC_CLANG} -E - > ${BUILD_DIR}/main.s
	${PIC_AS} \
		-mcpu=${CHIP} -mdfp=${DFP} \
		-Wl,-pkmain=0h \
		-o ${BUILD_DIR}/main.hex \
		${BUILD_DIR}/main.s
	cp ${BUILD_DIR}/main.hex .

clean:
	rm -rf ${BUILD_DIR}
	rm -f main.hex
