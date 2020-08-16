using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.UI.Interfaces;
using backendPoSlojevima.BL.Interfaces;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.UI
{
    public class InstitucijeKategorijaUI : IInstitucijeKategorijeUI
    {
        private readonly IInstitucijeKategorijeBL _IInstitucijeKategorijeBL;
        private readonly IKategorijeProblemaUI _IKategorijeProblemaUI;


        public InstitucijeKategorijaUI (IKategorijeProblemaUI IKategorijeProblemaUI, IInstitucijeKategorijeBL IInstitucijeKategorijeBL)
        {
            _IInstitucijeKategorijeBL = IInstitucijeKategorijeBL;
            _IKategorijeProblemaUI = IKategorijeProblemaUI;
        }

        public void dodajInstitucijiKategoriju(PrihvatanjeKategorije data)
        {
            _IInstitucijeKategorijeBL.dodajInstitucijiKategoriju(data);
        }

        public List<InstitucijeKategorije> getAllInstitucijeKategorije()
        {
            return _IInstitucijeKategorijeBL.getAllInstitucijeKategorije();
        }

        public List<Korisnik> getInstitucijeByIdKategorije(long idKategorije)
        {
            return _IInstitucijeKategorijeBL.getInstitucijeByIdKategorije(idKategorije);
        }

        public List<KategorijeProblema> getKategorijeByIdInstitucije(long idInstitucije)
        {
            var lista = _IInstitucijeKategorijeBL.getKategorijeByIdInstitucije(idInstitucije);
            var listaKategorija = _IKategorijeProblemaUI.getKategorijeByListaId(lista);
            return listaKategorija;
        }

        public int izmeniKategorijeZaKorisnika(long idKorisnika, List<long> kategorije)
        {
            return _IInstitucijeKategorijeBL.izmeniKategorijeZaKorisnika(idKorisnika, kategorije);
        }
    }
}
