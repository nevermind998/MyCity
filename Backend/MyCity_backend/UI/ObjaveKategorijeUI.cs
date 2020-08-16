using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.UI.Interfaces;
using backendPoSlojevima.BL.Interfaces;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.UI
{
    public class ObjaveKategorijeUI : IObjaveKategorijeUI
    {
        private readonly IObjaveKategorijeBL _IObjaveKategorijeBL;
        private readonly IKategorijeProblemaUI _IKategorijeProblemaUI;
      
        


        public ObjaveKategorijeUI( IObjaveKategorijeBL IObjaveKategorijeBL, IKategorijeProblemaUI IKategorijeProblemaUI)
        {
            _IObjaveKategorijeBL = IObjaveKategorijeBL;
            _IKategorijeProblemaUI = IKategorijeProblemaUI;
        }
        public void dodajObjaviKategoriju(PrihvatanjeObjave objava)
        {
            _IObjaveKategorijeBL.dodajObjaviKategoriju(objava);
        }

        public List<ObjaveKategorije> getAllObjaveKategorije()
        {
            return _IObjaveKategorijeBL.getAllObjaveKategorije();
        }

        public List<KategorijeProblema> getKategorijeByIdObjave(long idObjave)
        {
             return  _IObjaveKategorijeBL.getKategorijeByIdObjave(idObjave);
            
            /*  var listaKategorija = new List<KategorijeProblema>();
              foreach(var kategorija in lista)
              {
                  KategorijeProblema kat = new KategorijeProblema();
                  kat = _IKategorijeProblemaUI.getkategorijaById(kategorija);
                  listaKategorija.Add(kat);
              }
              return listaKategorija;*/
        }

        public List<Objave> getObjavuByIdKategorije(long kategorija)
        {
            return _IObjaveKategorijeBL.getObjaveByIdKategorije(kategorija);
        }
    }
}
